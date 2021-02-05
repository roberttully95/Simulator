function VisList = getNodeVisibility(iQ, verts, edges)
%GETVISIBLENODES Given a query vertex, generates the list of
%vertices that are visible from the query vertex.
    
    % Get sizes
    nVerts = size(verts, 1);
    nEdges = size(edges, 1);
    
    % Get query vertex
    Vq = [verts(iQ, :), iQ];
    
    % Initialize visibility
    VisList = NaN(1, nVerts);
    iVis = 1;
    
    % Add indices to vertices
    verts = [verts, (1:nVerts)'];
    
    % Setup
    flag = edges(1,1);
    Esub = NaN(nVerts, 2);
    index = 1;
    
    % Calculte subvertices and subedges by using vertex number.
    for i = 1:nEdges
         if iQ == edges(i,1)
            for j = 1:flag-1
                Esub(index,:) = edges(j,:);
                index = index+1;
            end
            for k = i:size(edges,1)-1
                if flag == edges(k,2) && i < nEdges
                    flag = edges(k+1,1);
                    for j = flag:nEdges
                        Esub(index,:)=edges(j,:);
                        index = index+1;
                    end
                    break
                end
            end
            break
        end
        if flag == edges(i, 2) && i < nEdges
           flag = edges(i+1,1);
        end
    end
    Esub = rmmissing(Esub);

    % Create subvertices.
    Vsub = verts(Esub(:,1), :);

    % Create angles list and sort.
    A = zeros(size(Vsub, 1), 1);
    for i = 1:size(Vsub,1)
        Vi = Vsub(i,:);
        A(i) = atan2d((Vi(2) - Vq(2)), (Vi(1) - Vq(1))); 
    end
    A = sort(A);

    % Run 'Rotatinal Plane Sweep Algoritm' by using line segments intersect
    % algorithm which is check intersects between two edges.
    for j=1:size(A,1)
        for i=1:size(Vsub,1) 

            % Get verts
            Vi = Vsub(i, 1:2);

            if A(j) == atan2d((Vi(2) - Vq(2)), (Vi(1) - Vq(1))) % Find vertex number

                i2 = Vsub(i, 3); % Get first vertex to connect.
                Ecopy = edges; % Copy edges.
                Ecopy(any(Ecopy' == i2),:) = []; % Clear own edges. 
                Ecopy(any(Ecopy' == iQ),:) = []; % Clear own edges.

                % Check all adges if intersect or not.
                intersection = 1;
                for k = 1:size(Ecopy, 1)
                    if isLineSegmentsIntersect(Vq(1:2), verts(i2,1:2), verts(Ecopy(k,1),1:2), verts(Ecopy(k,2),1:2) ) == 1
                        intersection = 0;
                    end
                end

                % If there is not an intersect then it's available to draw.
                if intersection == 1
                    VisList(iVis) = i2;
                    iVis = iVis + 1;
                end 
            end
        end
    end
    
    % Add the neighbor edges to visibility (in case they are along an edge
    % they may not be picked up as visible)
    for i = 1:nEdges
        if edges(i, 1) == iQ
            VisList(iVis) = edges(i, 2);
            iVis = iVis + 1;
        elseif edges(i, 2) == iQ
            VisList(iVis) = edges(i, 1);
            iVis = iVis + 1;
        end
    end
    
    % Remove NaN vals.
    VisList(isnan(VisList)) = [];
        
    % Remove redundant edges (A-B and B-A)
    VisList = unique(VisList);
end
