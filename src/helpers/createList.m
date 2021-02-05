function edgeList = createList(src, dst)
%NEIGHBORSTOEDGELIST Takes a single source index and a list of destination 
% indices and returns the edge list from src to dst.
    edgeList = horzcat(src + zeros(length(dst), 1), dst');
end