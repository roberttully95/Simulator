classdef Vehicle < handle
    %VEHICLE Vehicle class.
    
    properties
        x
        y
        th
        v
        tInit
        tEnd
        handle
        finished
    end
    
    properties (Dependent)
        pos
        pose
        vx
        vy
        lifeSpan
    end
    
    methods
        
        function this = Vehicle(x0, y0, th0, v0, t0)
            % VEHICLE2D Constructor taking initial conditions
            this.setInitialConditions(x0, y0, th0, v0, t0);
            this.tEnd = Inf;
        end
        
        function setInitialConditions(this, x0, y0, th0, v0, t0)
            % SETINITIALCONDITIONS Sets the initial conditions of the
            % vehicle. Can be invoked after the creation of the vehicle
            % object.
            this.x = x0;
            this.y = y0;
            this.th = th0;
            this.v = v0;
            this.tInit = t0;
            this.finished = false;
        end
        
        function propogate(this, dT)
            this.x = this.x + this.vx * dT;
            this.y = this.y + this.vy * dT;
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
        
        function val = get.lifeSpan(this)
            % GETLIFESPAN Returns the length of time for which the vehicle has been active.
            val = this.tEnd - this.tInit;
        end
        
        function  plot(this, ax, color)
            % PLOT Plots the 2D location of the vehicle.
            arrows(ax, this.x, this.y, 1, 90 - this.th * 180 / pi);
            scatter(ax, this.x, this.y, color, '*');
        end
        
        
    end
end

