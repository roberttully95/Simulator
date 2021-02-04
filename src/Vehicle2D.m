classdef Vehicle2D < handle
    %VEHICLE2D Vehicle2D class.
    
    properties
        x
        y
        th
        v
    end
    
    properties (Dependent)
        pos
        pose
        vx
        vy
    end
    
    methods
        
        function this = Vehicle2D(x0, y0, th0, v0)
            % VEHICLE2D Constructor taking initial conditions
            this.setInitialConditions(x0, y0, th0, v0);
        end
        
        function setInitialConditions(this, x0, y0, th0, v0)
            % SETINITIALCONDITIONS Sets the initial conditions of the
            % vehicle. Can be invoked after the creation of the vehicle
            % object.
            this.x = x0;
            this.y = y0;
            this.th = th0;
            this.v = v0;
        end
        
        
        function val = get.pos(this)
            % GETPOS Returns the 2D position of the vehicle.
            val = [this.x, this.y];
        end
        
        function val = get.pose(this)
            % GETPOS Returns the 2D pose of the vehicle.
            val = [this.x, this.y, this.th];
        end
        
        function val = get.vx(this)
            % GETVX Returns the x component of the velocity vector.
            val = this.v * cos(this.th);
        end
        
        function val = get.vy(this)
            % GETVY Returns the y component of the velocity vector.
            val = this.v * sin(this.th);
        end
        
        function  plot(this, ax, color)
            % PLOT Plots the 2D location of the vehicle.
            arrows(ax, this.x, this.y, 1, 90 - this.th * 180 / pi);
            scatter(ax, this.x, this.y, color, '*');
        end
        
        
    end
end

