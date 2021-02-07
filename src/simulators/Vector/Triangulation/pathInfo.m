function [len, perc] = pathInfo(pts)
%PATHLENGTH Determines the length of a series of points and the distance of
%each point along the path relative to the total distance.

    % Init 
    n = size(pts, 1);
    dists = zeros(n, 1);
    
    % Get distances.
    for i = 1:(n - 1)
        dists(i + 1) = dists(i) + norm(pts(i, :) - pts(i + 1, :));
    end
    
    % Get total distance and percent
    len = dists(end);
    
    % Get percentages
    perc = dists / len;
end

