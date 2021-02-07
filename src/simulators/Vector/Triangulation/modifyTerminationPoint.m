function pathsOut = modifyTerminationPoint(pathsIn, goal)
%MODIFYTERMINATIONPOINT Summary of this function goes here
%   Detailed explanation goes here

    pathsOut = pathsIn;

    n = size(pathsIn, 1);
    for i = 1:n
        p = pathsIn{i};
        
        % Get length and direction of final edge.
        vN = p(end-1,:);

        len = norm(vN - goal.pos);
        dir = (goal.pos - vN) / len;
        
        % Get new final point
        p(end, :) = vN + dir*(len - goal.r);
        pathsOut{i} = p;
    end
end

