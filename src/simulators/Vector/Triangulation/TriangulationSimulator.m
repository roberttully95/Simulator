classdef TriangulationSimulator < VectorSimulator
    %TRIANGULATIONSIMULATOR
    
    properties
        borderUnstablePoints
        triangles
        vehicleIndices
    end
    
    methods
        
        function this = TriangulationSimulator(varargin)
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
            
            % Get unstable points.
            this.borderUnstablePoints = getBorderUnstablePoints(this.verts, this.weights, this.edges);
            
            % Generate the trangulation from the border unstable points.
            this.triangles = triangulate(this.borderUnstablePoints, this.verts, this.shortestPath, this.Goal);
        
            % Determine the index of the triangle in which the vehicles are located.
            this.vehicleIndices = this.getVehicleIndices(this.Vehicles);
            
            % Plot if axis exists
            if this.hasAxis
                this.plotMap()
            end
        end
        
        function plotMap(this)
            
            if this.hasAxis
                % Call vector plotting function
                plotMap@VectorSimulator(this);

                % Plot triangles
                for i = 1:size(this.triangles, 2)
                    this.triangles(i).plot(gca, 'g');
                    v = this.triangles(i).centroid;
                    arrows(this.ax, v(1), v(2), 1, 90 - atan2(this.triangles(i).Dir(2), this.triangles(i).Dir(1)) * (180 / pi))
                end
            end
        end
        
        function propogate(this)
            
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

                % If it has changed triangles, update heading / velocity.
                if ~this.triangles(this.vehicleIndices(i)).containsPt(v.pos)
                    
                    % Get the next index
                    next = this.triangles(this.vehicleIndices(i)).Next;
                    
                    % Check if at goal
                    if isnan(next)
                        this.Vehicles(i).finished = true;
                        this.Vehicles(i).tEnd = this.t;
                    else
                        this.vehicleIndices(i) = next;
                        dir = this.triangles(this.vehicleIndices(i)).Dir;
                        v.th = atan2(dir(2), dir(1));
                        this.Vehicles(i) = v;
                    end
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
        
        function indices = getVehicleIndices(this, vehicles)
            %GETVEHICLEINDICES 
            
            n = size(vehicles, 2);
            indices = NaN(n, 1);
            for i = 1:n
                pt = vehicles(i).pos;
                for j = 1:size(this.triangles, 2)
                    if this.triangles(j).containsPt(pt)
                        indices(i) = j;
                        dir = this.triangles(j).Dir;
                        vehicles(i).th = atan2(dir(2), dir(1));
                    end
                end
            end 
            
        end
        
    end
end

