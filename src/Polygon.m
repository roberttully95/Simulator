classdef Polygon < handle
    %POLYGON Extension of polyshape built-in class.
    
    properties (Access = public)
        polyshape
    end
    
    properties (Dependent)
        x
        y
        bounds
        verts
        length
    end
    
    methods
        
        function this = Polygon(coords)
            %POLYGON Constructor for polygon.
            
            % Make coordinates clockwise
            coords = Polygon.toClockwise(coords);
            
            % Generate polyshape
            this.polyshape = polyshape(coords);
            
            % Ensure convex
            if ~this.convex()
                warning("Provided polygon is not convex.");
            end
        end
        
        function selfBuffer(this, d)
            % BUFFER Buffers the current polygon by a specified amount. 
            this.polyshape = polybuffer(this.polyshape, d,...
                'JointType', 'miter', 'MiterLimit', 2);
        end
        
        function val = buffer(this, d)
            % BUFFER Buffers the current polygon by a specified amount and
            % returns the output. The current polygon is left unmodified.
            val = polybuffer(this.polyshape, d,...
                'JointType', 'miter', 'MiterLimit', 2);
        end
        
        function val = get.verts(this)
            %GETVERTS Returns the list of polygon vertices.
            val = this.polyshape.Vertices;
        end
        
        function val = get.x(this)
            %GETX Returns the list of polygon x coordinates.
            val = this.verts(:, 1);
        end
        
        function val = get.y(this)
            %GETY Returns the list of polygon y coordinates.
            val = this.verts(:, 2);
        end
        
        function val = get.length(this)
            %GETLENGTH Returns the number of vertices in the polygon.
            val = size(this.verts, 1);
        end
        
        function val = get.bounds(this)
            %GETBOUNDS Returns the bounds of the polygon object.
            val.xMin = min(this.x);
            val.xMax = max(this.x);
            val.yMin = min(this.y);
            val.yMax = max(this.y);
        end
        
        function plot(this, ax, color)
            %PLOT Plots the polygon object.
            plot(ax, this.polyshape, 'FaceColor', color);
        end
        
        function val = convex(this)
            % CONVEX Determines if the polygon is convex.
            
            % Triangle case
            n = this.length;
            if n < 4
                val = true;
                return
            end
            
            % Can determine if the polygon is convex based on the direction the angles
            % turn.  If all angles are the same direction, it is convex.
            v1 = [this.x(1) - this.x(end), this.y(1) - this.y(end)];
            v2 = [this.x(2) - this.x(1), this.y(2) - this.y(1)];
            signPoly = sign(det([v1; v2]));
            
            % Check subsequent vertices
            for k = 2:(n-1)
                v1 = v2;
                v2 = [this.x(k+1) - this.x(k), this.y(k+1) - this.y(k)]; 
                curr_signPoly = sign(det([v1; v2]));
                % Check that the signs match
                if not (isequal(curr_signPoly, signPoly))
                    val = false;
                    return
                end
            end

            % Check the last vectors
            v1 = v2;
            v2 = [this.x(1) - this.x(end), this.y(1) - this.y(end)];
            curr_signPoly = sign(det([v1; v2]));
            val = isequal(curr_signPoly, signPoly);
        end
        
        function val = containsPt(this, pts)
            v = this.verts;
            val = inpoly2(pts, v);
        end
    end
    
    methods (Static, Access = private)
        
        function val = toClockwise(val)
            %TOCLOCKWISE Orients a set of points in a clockwise
            %direction.
            x = val(:, 1);
            y = val(:, 2);
            xcent = mean(x);
            ycent = mean(y);
            [~, order] = sort(atan2(y - ycent, x - xcent), 'descend');
            val = val(order, :);
        end
        
    end
end

