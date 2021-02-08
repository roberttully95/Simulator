classdef (Abstract) VectorSimulator < Simulator
    %VECTORSIMULATOR
    
    properties
        verts
        edges
        visList
        visArray
        graph
        weights
        
        shortestPath
    end
    
    properties (Dependent)
        obsVerts
        obsEdges
        nVerts
        nEdges
    end
    
    methods
        
        function init(this, file, ax)
            %INIT Initializes the vector simulator.
      
            %Init simulator
            init@Simulator(this, file, ax); 
            
            % Construct vertex and edge lists.
            this.verts = VectorSimulator.getVertices(this.Obstacles, this.Goal, this.Border);
            this.edges = VectorSimulator.getEdges(this.Obstacles, this.Border);
            
            % Get visibility
            [this.visList, this.visArray] = VectorSimulator.getVisibility(this.verts, this.edges);
            
            % Create graph
            this.graph = createGraph(this.verts, this.visList);
            
            % Get weights
            this.weights = distances(this.graph, 1:this.nVerts, this.nVerts);
            
            % Get shortest path from each node to the goal.
            [this.shortestPath, ~] = VectorSimulator.getShortestPaths(this.graph);
        end
        
        function plotMap(this)
            %PLOTMAP Plots the map in which the simulation occurs.
            
            if this.hasAxis
                % Call simulator plot map
                plotMap@Simulator(this, this.ax, "Triangulation Simulation");

                % Plot Obstacles
                for i = 1:size(this.Obstacles, 2)
                    this.Obstacles(i).plot(this.ax, 'k');
                end

                % Plot Goal
                this.Goal.plot(this.ax , 'r');       
            end
        end
        
        function plotShortestPath(this, ax, i)
            
            % Get vertex locations.
            vertices = this.verts(this.shortestPath{i}, 1:2);
            plot(ax, vertices(:, 1), vertices(:, 2), 'r');
        end
        
    end
    
    % GETTERS
    methods
        
        function val = get.obsVerts(this)
            val = this.verts(this.verts(:, 3) == 1, 1:2);
        end
        
        function val = get.obsEdges(this)
            val = this.edges(this.edges(:, 3) == 1, 1:2);
        end
        
        function val = get.nVerts(this)
            val = size(this.verts, 1);
        end
        
        function val = get.nEdges(this)
            val = size(this.edges, 1);
        end
        
    end
    
    % HELPING FUNCTIONS
    methods (Static)
        
        function verts = getVertices(Obstacles, Goal, Border)
            
            % Get obstacle vertices
            obsSizes = arrayfun(@(o) o.length, Obstacles);
            ObsVerts = NaN(sum(obsSizes), 3);
            vStart = 1;
            for iObs = 1:length(obsSizes)
                sz = obsSizes(iObs);
                vEnd = vStart + sz - 1;
                ObsVerts(vStart:vEnd, :) = [Obstacles(iObs).verts, repelem(1, sz)'];
                vStart = vEnd + 1;
            end
            
            % Add goal vertex and border vertices   
            sz = Border.length;
            verts = [ObsVerts; Border.verts, repelem(2, sz)'; Goal.pos, 3 ]; 
        end
        
        function edges = getEdges(Obstacles, Border)
            %GETEDGES Generates a list of edges given an obstacle Polygon array and 
            %a goal location.

            % Get obstacle edges
            obsSizes = arrayfun(@(o) o.length, Obstacles);
            ObsEdges = NaN(sum(obsSizes), 3);
            eStart = 1;
            for iObs = 1:length(obsSizes)
                sz = obsSizes(iObs);
                eEnd = eStart + sz - 1;
                ObsEdges(eStart:eEnd, :) = [sequenceWrap(eStart, eEnd), repelem(1, sz)'];
                eStart = eEnd + 1;
            end

            % Add the goal edge and border edges
            sz = Border.length;
            edges = [ObsEdges;...
                     sequenceWrap(1, sz) + eStart - 1, repelem(2, sz)';...
                     repelem(eStart + sz, 2), 3];
        end
        
        function [list, array] = getVisibility(verts, edges)
            
            % Get size.
            n = size(verts, 1);

            % Initialize visibility array.
            array = NaN(n, n);
            list = NaN(n * n, 2);

            % Iterate through all vertices.
            eStart = 1;
            for i = 1:n
                % Get indices of vertices visible to vertex i
                Vis = getNodeVisibility(i, verts(:, 1:2), edges(:, 1:2));
                Vis = Vis(Vis(:) > i);
                eEnd = eStart + length(Vis) - 1;

                % Create visibility list and array
                list(eStart:eEnd, :) = createList(i, Vis);
                array(i, 1:length(Vis)) = Vis;

                % Increment
                eStart = eEnd + 1;
            end

            % Remove nan rows
            list(any(isnan(list), 2), :) = [];
        end
        
        function [vertexPaths, edgePaths] = getShortestPaths(graph)
            %GETSHORTESTPATHS Creates an n x n array where each row
            %represents the vertex indices traversed to get to the goal
            %location. The goal location is at index m.

            % Define sizes
            n = size(graph.Nodes, 1);

            % Initialize the shortest path array.
            vertexPaths = cell(n, 1);
            edgePaths = cell(n, 1);
            % Iterate through all non-goal vertices
            for i = 1:n
                % Iterate through all goal vertices
                [SP, ~, EP] = shortestpath(graph, i, n);
                edgePaths{i} = table2array(graph.Edges(EP, 'EndNodes'));
                vertexPaths{i} = SP;      
            end
        end
    end
end

