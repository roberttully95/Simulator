classdef SimVehicle < Vehicle2D
    %SIMVEHICLE Extension of vehicle class for simulation vehicles.
    
    properties
        tInit
        tEnd
    end
    
    methods
        
        function this = SimVehicle(varargin)
            %SIMVEHICLE Construct an instance of this class
            %   Detailed explanation goes here
            
            % Parse input
            ics  = cell2mat(varargin);
            x0 = ics(1);
            y0 = ics(2);
            th0 = ics(3);
            v0 = ics(4);
            t0 = ics(5);
            
            % Parent Constructor
            this@Vehicle2D(x0, y0, th0, v0);
            
            % Set params
            this.tInit = t0;
            this.tEnd = Inf;
        end
        
    end
end

