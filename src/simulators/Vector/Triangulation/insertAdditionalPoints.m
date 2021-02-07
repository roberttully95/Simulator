function newPaths = insertAdditionalPoints(paths)
%INSERTADDITIONALPOINTS
    
    n = length(paths);
    newPaths = cell(2, 1);
    
    % Determine size of each path
    sizes = NaN(n, 1);
    for i = 1:length(paths)
        sizes(i) = size(paths{i}, 1);
    end
    
    % Generate list of unique locations
    iStart = 1;
    locs = NaN(sum(sizes), 1);
    for i = 1:n
        iEnd = iStart + sizes(i) - 1;
        [~, locs(iStart:iEnd)] = pathInfo(paths{i});
        iStart = iEnd + 1;
    end
    
    % Re-calculate points along paths
    for i = 1:n
        newPaths{i} = insertPoints(paths{i}, locs);
    end
    
end

