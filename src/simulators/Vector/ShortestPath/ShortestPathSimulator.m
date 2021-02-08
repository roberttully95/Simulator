classdef ShortestPathSimulator < VectorSimulator
    %SHORTESTPATHSIMULATOR
    
    properties
        vehicleShortestPaths
        initialLocs
        vehicleIndices
    end
    
    methods
        
        function this = ShortestPathSimulator(varargin)
            %TRIANGULATIONSIMULATOR Construct an instance of this class
            %   Detailed explanation goes here

            % Parse inputs
            if nargin == 1
                file = varargin{1};
                ax = NaN;
            elseif nargin == 2
                file = varargin{1};
                ax = varargin{2};
            end
            
            % Initialize the vector generator.
            this.init(file, ax)
            
            % Get the shortest path for the vehicles
            this.vehicleShortestPaths = this.getVehicleShortestPaths();
            
            % Determine the index of the triangle in which the vehicles are located.
            this.vehicleIndices = ones(size(this.Vehicles, 2), 1);
            
            % Initialize previous node indices
            this.initialLocs = this.getInitialLocs();
            
            % Set all vehicles heading based on the next node index.
            this.setInitialHeadings();
            

            % Plot if axis exists
            if this.hasAxis
                this.plotMap()
            end
        end
        
        function plotMap(this)
            
            if this.hasAxis
                % Call vector plotting function
                plotMap@VectorSimulator(this);
            end
        end
        
        function propogate(this)
            %PROPOGATE 
            
            % Init all finished
            allFinished = true;

            % Store x and y positions for all vehicles
            x = NaN(size(this.Vehicles, 2), 1);
            y = NaN(size(this.Vehicles, 2), 1);
            
            % Iterate through vehicles.
            delta = this.dT;
            for i = 1:size(this.Vehicles, 2)
                
                % If finished skip
                if this.Vehicles(i).finished
                    continue;
                end
                
                % Don't consider ended vehicles
                if this.t < this.Vehicles(i).tInit
                    continue;
                end
                allFinished = false;
                
                
                % Get vehicle
                v = this.Vehicles(i);
                
                % Propogate and assign x and y vals
                v.propogate(delta); 
                x(i) = v.x;
                y(i) = v.y;

                % Check halfplane
                path = this.vehicleShortestPaths{i};
                vCurr = this.verts(path(this.vehicleIndices(i)), 1:2);
                if this.vehicleIndices(i) == 1
                    vPrev = this.initialLocs(i, :);
                else
                	vPrev = this.verts(path(this.vehicleIndices(i) - 1), 1:2);
                end
                v.th = atan2(vCurr(2) - vPrev(2), vCurr(1) - vPrev(1));
                
                % Generate normal vector
                n = (vCurr - vPrev) / norm(vCurr - vPrev);
            
                % Check halfplane
                d = (v.pos - vCurr)*n';
                if d >= 0
                    
                    % Check if we're at the goal
                    if isequal(vCurr, this.Goal.pos)
                        v.finished = true;
                        v.tEnd = this.t;
                    else
                        this.vehicleIndices(i) = this.vehicleIndices(i) + 1;
                    end
                    this.Vehicles(i) = v;
                end
            end
            
            % Single call to 'scatter' to plot all points
            if this.hasAxis
                hold(this.ax, 'on');
                delete(this.handle)
                this.handle = scatter(x, y, 'r', '*');
            end
            
            % Set simulation to be finished
            if allFinished
                this.finished = true;
            end
            
            % Update time
            this.t = this.t + delta;
        end
        
        function paths = getVehicleShortestPaths(this)
            
            % Get non-border vertices
            Vnb = this.verts(this.verts(:, 3) ~= 2, 1:2);
            nnb = size(Vnb, 1);
            nb = size(this.verts, 1) - nnb;
            Enb = this.edges(this.edges(:, 3) ~= 2, 1:2);
            Enb(end, :) = Enb(end, :) - nb;
            
            % Get the weights
            W = this.weights(this.verts(:, 3) ~= 2);
            
            % Init indices
            n = size(this.Vehicles, 2);
            
            % Init Paths
            paths = cell(n, 1);
            
            % Iterate through vehicles
            for i = 1:n
                
                % Get position
                pt = this.Vehicles(i).pos;
                xp = pt(1);
                yp = pt(2);
                
                % Get visibility
                vis = getNodeVisibility(nnb + 1, [Vnb; pt], [Enb; nnb + 1, nnb + 1]);  
                vis(end) = [];
                xv = Vnb(vis, 1);
                yv = Vnb(vis, 2);
                
                % Get node index of next node along shortest path.
                dists = sqrt((xp - xv).^2 + (yp - yv).^2) + W(vis);
                iMin = vis(dists == min(dists));
                
                % If multiple shortest, just choose first. TODO: Check
                if length(iMin) > 1
                    iMin = iMin(1);
                end
                
                % If the goal is the closest we need to add the offset
                if iMin == nnb
                    iMin = iMin + nb;
                end
                
                % Assign
                paths{i} = this.shortestPath{iMin};
            end
        end

        function locs = getInitialLocs(this)
            
            n = size(this.Vehicles, 2);
            locs = NaN(n, 2);
            for i = 1:size(this.Vehicles, 2)
                locs(i, :) = this.Vehicles(i).pos;
                
            end
            
        end
        
        function setInitialHeadings(this)
            
            for i = 1:size(this.Vehicles, 2)
                path = this.vehicleShortestPaths{i};
                ptA = this.Vehicles(i).pos;
                ptB = this.verts(path(1), 1:2);
                this.Vehicles(i).th = atan2(ptB(2) - ptA(2), ptB(1) - ptA(1));
            end
        end

    end
end

