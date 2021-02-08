function triangles = startToEnd(p1, p2)
    
    % Get params
    m = size(p1, 1);
    n = size(p2, 1);
    
    % Init triangles
    triangles = Triangle.empty(max(m, n) + 1, 0);
    
    % Initialize
    i = 1;
    j = 1;
    index = 1;
    while (i < m || j < n)
        
        % Get the current vertices
        v1a = p1(min(i, m), :);
        v2a = p2(min(j, n), :);

        % Get the next vertices
        v1b = p1(min(i + 1, m), :);
        v2b = p2(min(j + 1, n), :);

        % Get distances
        d1 = norm(v1a - v2b);
        d2 = norm(v1b - v2a);

        % If one path is finished, we need to do the other.
        if i == m
            triangles(index) = Triangle(v2a, v1a, v2b, 'Vertices');
            triangles(index).Prev = index - 1;
            j = j + 1;
            index = index + 1;
            continue;
        elseif j == n
            triangles(index) = Triangle(v1a, v2a, v1b, 'Vertices');
            triangles(index).Prev = index - 1;
            i = i + 1;
            index = index + 1;
            continue;
        end

        % Create edge
        if d1 <= d2
            triangles(index) = Triangle(v2a, v1a, v2b, 'Vertices');
            triangles(index).Prev = index - 1;
            triangles(index).Next = index + 1;
            j = j + 1;
            index = index + 1;
            continue;
        else
            triangles(index) = Triangle(v1a, v2a, v1b, 'Vertices');
            triangles(index).Prev = index - 1;
            triangles(index).Next = index + 1;
            i = i + 1;
            index = index + 1;
            continue;
        end

    end

end

