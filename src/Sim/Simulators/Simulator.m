classdef (Abstract) Simulator < handle
    %SIMULATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fileHandler
        simData
        Vehicles
        finished
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
        
        function init(this, file)
            
            % Load simulation data
            this.fileHandler = FileHandler(cd);
            this.simData = this.fileHandler.read(file);
            
            % Setup random number generator
            rng(this.seed, 'combRecursive');
            
            % Initialize Vehicles
            this.initVehicles();
            
            % Initialize other parameters
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
            this.Vehicles = SimVehicle.empty(0, n);
            for i = 1:n
                [x, y, th] = this.Border.randomInitialPose();
                this.Vehicles(i) = SimVehicle(x, y, th, this.velocity, t0(i));
            end
        end
    end
    
    methods (Abstract)
        plotMap(this, ax);
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

