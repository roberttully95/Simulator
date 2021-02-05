classdef Circle < handle
    %CIRCLE Represents a goal in a map.
    
    properties
        x
        y
        r
    end
    
    properties (Dependent)
        pos
    end
    
    methods
        
        function this = Circle(pos, rad)
            %CIRCLE Construct a circle instance.
            this.x = pos(1);
            this.y = pos(2);
            this.r = rad;
        end
        
        function val = get.pos(this)
            % Getter for x value.
            val = [this.x, this.y];
        end
        
        function val = containsPoint(this, p)
            % INSIDE Determines if a point is located within the goal.
            val = (norm(this.pos - p) <= this.r);
        end
        
        function plot(this, axis, color)
            hold(axis, 'on');
            th = 0:pi/50:2*pi;
            xunit = this.r * cos(th) + this.x;
            yunit = this.r * sin(th) + this.y;
            patch(axis, xunit, yunit, color)
        end
        
    end

end

