classdef Border < Polygon
    %BORDER Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function this = Border(args)
            this@Polygon(args);
        end
        
        function [x, y, th] = randomInitialPose(this)
            %RANDOMINITIALPOSE Generates a random point along the
            %boundary of the polygon.
            
            % Get info
            v = this.verts;
            n = this.length;

            % Init dists
            dists = zeros(n + 1, 1);
            for i = 1:n
                j = mod(i, n) + 1;
                dists(i + 1) = norm(v(j, :) - v(i, :)) + dists(i);
            end

            % Generate random number between 0 and dists(end)
            loc = dists(end).*rand;

            % Determine indices of vertices it is between
            i = find(dists < loc, 1, 'last');
            j = mod(i, n + 1) + 1;

            % Linearly interpolate
            dA = abs(dists(i) - loc);
            dB = abs(dists(j) - loc);
            p = dA / (dA + dB);

            % Get actual vertex indices
            if i == n + 1
                i = 1;
            elseif j == n + 1
                    j = 1;
            end

            % Get position
            pt = v(i, :) * p + (1 - p) * v(j, :);
            x = pt(1);
            y = pt(2);
            
            % Get theta
            dir = (v(i, :) - v(j, :))/ norm(v(i, :) - v(j, :));
            dir = [-dir(2), dir(1)];
            th = atan2(dir(2), dir(1));
        end
    end
end

