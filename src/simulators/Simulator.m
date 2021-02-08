classdef (Abstract) Simulator < handle
    %SIMULATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fileHandler
        simData
        Vehicles
        finished
        t
    end
    
    properties (Access = protected)
        handle
        ax;
        hasAxis;
    end
    
    properties (Dependent)
        dT
        fSpawn
        tEnd
        seed
        velocity
        Border
        Obstacles
        Goal
    end
    
    % PUBLIC METHODS
    methods
        
        function init(this, file, ax)
            
            % Save axis
            if ~isgraphics(ax)
                this.ax = NaN;
                this.hasAxis = false;
            else
                this.ax = ax;
                this.hasAxis = true;
            end
            
            % Load simulation data
            this.fileHandler = FileHandler(cd);
            this.simData = this.fileHandler.read(file);
            
            % Setup random number generator
            rng(this.seed, 'combRecursive');
            
            % Initialize Vehicles
            this.initVehicles();
            
            % Initialize other parameters
            this.t = 0;
            this.finished = (this.tEnd == 0);
        end
        
        function plotVehicles(this, ax)
            for i = 1:size(this.Vehicles, 2)
                this.Vehicles(i).plot(ax, 'r');
            end
        end
        
        function val = isFinished(this)
            val = this.finished;
        end
        
        
        function initVehicles(this)
            %INITVEHICLES Creates a vehicle array.
            
            % Create array of spawn times
            t0 = 0:(1/this.fSpawn):this.tEnd;
            
            % Determine number of vehicles to be created.
            n = length(t0);
            
            % Create vehicles array.
            this.Vehicles = Vehicle.empty(0, n);
            for i = 1:n
                [x, y, th] = this.Border.randomInitialPose();
                this.Vehicles(i) = Vehicle(x, y, th, this.velocity, t0(i));
            end
        end
        
        function plotMap(this, ax, axTitle)
            
            if this.hasAxis
                % Setup axis
                cla(ax)
                bounds = this.Border.bounds;
                ax.XLim = [bounds.xMin, bounds.xMax];
                ax.YLim = [bounds.yMin, bounds.yMax];
                ax.DataAspectRatio = [1, 1, 1];
                hold(ax , 'on');

                % Label Axes
                xlabel(ax, "x (meters)");
                ylabel(ax, "y (meters)");

                % Make Title
                title(ax, axTitle);
            end
        end
        
        function val = getDistances(this)
            %GETDISTANCES
            
            n = size(this.Vehicles, 2);
            val = NaN(n, 1);
            
            % Return NaNs if simulation not yet finished.
            if ~this.finished
                warning("Simulation not yet finished")
            end
            
            % Get distances travelled
            for i = 1:n
                t1 = this.Vehicles(i).tInit;
                t2 = this.Vehicles(i).tEnd;
                val(i) = (t2 - t1) * this.Vehicles(i).v;
            end
        end
    end
    
    
    % GETTERS
    methods 
        
        function val = get.Border(this)
            val = this.simData.Border;
        end
        
        function val = get.Obstacles(this)
            val = this.simData.Obstacles;
        end
        
        function val = get.Goal(this)
            val = this.simData.Goal;
        end
        
        function val = get.dT(this)
            val = this.simData.properties.deltaT;
        end
        
        function val = get.fSpawn(this)
            val = this.simData.properties.spawnFreq;
        end
        
        function val = get.tEnd(this)
            val = this.simData.properties.duration;
        end
        
        function val = get.seed(this)
            val = this.simData.properties.seed;
        end
        
        function val = get.velocity(this)
            val = this.simData.properties.velocity;
        end
        
    end
end

