function Graph = createGraph(verts, visList)

    % Get the distance from nodes to visible nodes.
    src = verts(visList(:, 1), 1:2);
    dst = verts(visList(:, 2), 1:2);
    dists = zeros(size(src, 1), 1);
    for i = 1:size(dists, 1)
        dists(i) = norm(src(i, :) - dst(i, :));
    end

    % Create graph object from edge visiblity and distances
    Graph = graph(visList(:, 1), visList(:, 2), dists);
end

