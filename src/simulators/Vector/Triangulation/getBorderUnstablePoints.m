function points = getBorderUnstablePoints(V, W, E)
    
    % Get start index of borders
    offset = find(V(:, 3) == 2, 1, 'first');
    
    % Separate out the border edges and the non-border edges.
    Vb = V(V(:, 3) == 2, 1:2);
    Vnb = V(V(:, 3) ~= 2, 1:2);
    nb = size(Vb, 1);
    nnb = size(Vnb, 1);
    Eb = E(E(:, 3) == 2, 1:2) - offset + 1;
    Enb = E(E(:, 3) ~= 2, 1:2);
    Enb(end, :) = Enb(end, :) - nb;
    
    % Determine the amount ob 
    nObs = sum(Enb(:, 1) > Enb(:, 2));
    
    % Init
    points = UnstablePoint.empty(0, nObs);
    currPoint = 1;
    
    % Create list of possible index combinations.
    list = comboList(nnb - 1);

    % Iterate through edge list
    for row = 1:size(list, 1)

        % Get indices
        i = list(row, 1);
        j = list(row, 2);

        % Get vertices and weights
        V1 = Vnb(i, 1:2);
        W1 = W(i);
        V2 = Vnb(j, 1:2);
        W2 = W(j);

        % Now iterate through the edges
        for k1 = 1:nb
            
            % Get the edge
            L1 = Vb(Eb(k1, 1), 1:2);
            L2 = Vb(Eb(k1, 2), 1:2);
            
            % Get the unstable points
            Pts = getUnstablePoint(V1, V2, W1, W2, L1, L2, 1e-3);
            for l = 1:size(Pts, 1)
                pt = Pts(l, :);
                
                % Get visibility of unstable point. Remove
                % self-intersection.
                vis = getNodeVisibility(nnb + 1,...
                    [Vnb(:, 1:2); pt],...
                    [Enb(:, 1:2); nnb + 1, nnb + 1]);
                vis(end) = [];

                % The original two vertices must be in the
                % visibility list.
                if ~any(vis(:) == i) || ~any(vis(:) == j)
                    continue;
                end
                
                % The goal cannot be in the visibility list or else it is a
                % stable point.
                if any(vis(:) == nnb)
                    continue;
                end
                
                % Minimum distance from unstable point to all
                % other visible point.
                nVis = size(vis, 2);
                newDists = NaN(nVis, 1);
                for m = 1:nVis
                    newDists(m) = W(vis(m)) + norm(Vnb(vis(m), 1:2) - pt);
                end

                % Get shortest distances
                [newDistsSorted, idSorted] = sort(newDists);
                if newDistsSorted(2) - newDistsSorted(1) < 0.001
                    I = sort(vis(idSorted(1:2)'));
                else
                    I = vis(idSorted(1)');
                end

                % If index is the same as either of the source
                % nodes, then it is a valid unstable point.
                if all(I == [i, j])
                    
                    % Centroid of next nodes
                    vc = mean([V1; V2], 1);

                    % Get direction
                    dir = (vc - pt) / norm(vc - pt);
                    n = [-dir(2), dir(1)];
                    
                    % Init with right and left nodes
                    if (V1 - vc)*n' < 0
                        points(currPoint) = UnstablePoint(pt, [i, j]);
                    else
                        points(currPoint) = UnstablePoint(pt, [j, i]);
                    end
                    currPoint = currPoint + 1;
                end
            end
        end
    end

    % Remove duplicate unstable points
    points = UnstablePoint.unique(points);
end