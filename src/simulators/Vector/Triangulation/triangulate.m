function triangles = triangulate(unstablePoints, verts, shortestPaths, goal)
%TRIANGULATE Summary of this function goes here
%   Detailed explanation goes here

    % Get size
    n = size(unstablePoints, 2);
    
    % Sort unstable points ccw
    unstablePoints = sortUnstablePoints(unstablePoints);
   
    % Get paths 
    j = n;
    for i = 1:n
        paths{2*i - 1} = [unstablePoints(j).pos; verts(shortestPaths{unstablePoints(j).iRight}, 1:2)]; %#ok<AGROW>
        paths{2*i} = [unstablePoints(i).pos; verts(shortestPaths{unstablePoints(i).iLeft}, 1:2)]; %#ok<AGROW>
        j = i;
    end
    
    % Add intermediate points
    paths = insertAdditionalPoints(paths);

    % Remove goal and replace with intersection of circle.
    paths = modifyTerminationPoint(paths, goal);
    
    % Plot triangulation from unstable point to goal
    triangles = [];
    for i = 1:n
        triangles = [triangles, startToEnd(paths{2*i - 1}, paths{2*i})]; %#ok<AGROW>
    end
    
    % Adjust previous and next indices
    n = size(triangles, 2);
    for i = 1:n
        if triangles(i).Prev ~= 0
            triangles(i).Prev = i - 1;  %#ok<AGROW>
        end
        
        if ~isnan(triangles(i).Next)
            triangles(i).Next = i + 1;  %#ok<AGROW>
        end
    end
end

function unstablePointsOut = sortUnstablePoints(unstablePointsIn)

    % Copy
    unstablePointsOut = unstablePointsIn;
    
    % Get x and y
    n = size(unstablePointsIn, 2);
    x = NaN(n, 1);
    y = NaN(n, 1);
    for i = 1:n
        x(i) = unstablePointsIn(i).x;
        y(i) = unstablePointsIn(i).y;
    end
    
    % Get centroid
    xc = mean(x);
    yc = mean(y);
    
    % Sort angles
    thetas = atan2((y - yc), (x - xc));
    [~, I] = sort(thetas);
    
    % Re-order
    for i = 1:n
        unstablePointsOut(i) = unstablePointsIn(I(i));
    end
end