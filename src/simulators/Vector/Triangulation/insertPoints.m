function outPath = insertPoints(path, locs)
%INSERTPOINTS Summary of this function goes here
%   Detailed explanation goes here
    
    % Get distance from source to points to be added.
    [len, perc] = pathInfo(path);
    myDists = perc * len;
    dists = sort(setdiff(locs * len, myDists), 'ascend');
    n = size(dists, 1);
    m = size(path, 1);
    
    % Case in which there are no new points to add
    if n == 0
        outPath = path;
        return;
    end
    
    % Init points of insertion
    p = NaN(n, 2);
    ind = NaN(n, 1);
    
    % Iterate through points
    for i = 1:n
        dist = dists(i);
        
        j = find(myDists < dist, 1, 'last');
        
        % Difference
        deltaD = dists(i) - myDists(j);

        % Get direction vec
        dir = path(j + 1, :) - path(j, :);
        dir = dir / norm(dir);
        
        % Get new point
        p(i, :) = path(j, :) + deltaD * dir;
        ind(i) = j;
    end
    
    % Get minimum index
    nAdded = 0;
    i = 1;
    outPath = NaN(m + n, 2);
    while i <= length(path)
        
        % Add from input path
        outPath(i + nAdded, :) = path(i, :);
        
        % Insert in between
        nToAdd = sum(ind(:) == i);
        for j = 1:nToAdd
            outPath(i + j, :) = p(j, :);
            nAdded = nAdded + 1;
        end
        
        i = i + 1;
    end
end

