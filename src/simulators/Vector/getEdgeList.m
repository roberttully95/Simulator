function Edges = getEdgeList(Obstacles, Border)
    %GETEDGES Generates a list of edges given an obstacle Polygon array and 
    %a goal location.

    % Get obstacle edges
    obsSizes = arrayfun(@(o) o.length, Obstacles);
    ObsEdges = NaN(sum(obsSizes), 3);
    eStart = 1;
    for iObs = 1:length(obsSizes)
        sz = obsSizes(iObs);
        eEnd = eStart + sz - 1;
        ObsEdges(eStart:eEnd, :) = [sequenceWrap(eStart, eEnd), repelem(1, sz)'];
        eStart = eEnd + 1;
    end
    
    % Add the goal edge and border edges
    sz = Border.length;
    Edges = [ObsEdges;...
             sequenceWrap(1, sz) + eStart - 1, repelem(2, sz)';...
             repelem(eStart + sz, 2), 3];
end