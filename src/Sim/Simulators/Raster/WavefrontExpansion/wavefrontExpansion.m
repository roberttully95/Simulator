function [map_wavefront, cost_map] = wavefrontExpansion(geofence, obsMap)

    % Get size
    nrows = size(obsMap, 1);
    ncols = size(obsMap, 2);

    % Initialize wavefront map
    map_wavefront = zeros(nrows, ncols);

    % Place geo-fence borders (goals) on obstacle map with value 2.
    for i = 1:size(geofence, 1)
        if(geofence(i, 1) <= nrows && geofence(i, 2) <= ncols)
            obsMap(geofence(i, 1), geofence(i, 2)) = 2; 
        end
    end

    checked = 1; % this variable will indicate that at least one cell has been updated
    min_now = 2; % this is the current value of the wave front

    % the following loop creates a wave-front map using an 8-points
    % connectivity. In this map the border of the geo-fence is the set of
    % goals. The end product of this loop is a map in which the value of
    % each cell represents the cost to reach the geo-fence.
    while checked == 1
        checked = 0;
        min_now = min_now + 1; % increment value of the wave front

        for c = 1:ncols
            for r = 1:nrows
                
                if obsMap(r, c) ~= 0 % check if cell is occupied by an obstacle
                    continue;
                end

                diag = 0; % flag that is set to 1 if the movement must be diagonal
                min = -1;
                n(1:8) = -1;
                
                % in the following lines the value of each neighboring
                % cell is read (8-points connectivity is used)
                if c > 1
                    n(1) = obsMap(r, c - 1);
                end

                if r > 1
                    n(2) = obsMap(r-1, c);
                end

                if r < nrows
                    n(3) = obsMap(r+1, c);
                end

                if c < ncols
                    n(4) = obsMap(r, c + 1);
                end

                if r < nrows && c < ncols
                    n(5) = obsMap(r + 1, c + 1);
                end

                if c > 1 && r < nrows
                    n(6) = obsMap(r + 1, c - 1);
                end

                if c > 1 && r > 1
                    n(7) = obsMap(r - 1, c - 1);
                end

                if c < ncols && r - 1 >= 1
                    n(8) = obsMap(r - 1, c + 1);
                end
                
                % search for the lowest value among the velues of the neighboring cells
                for z = 1:8
                    if(min > 0 && n(z) > 1)
                        if(n(z) < min)
                            min = n(z);
                            if z >= 5
                               diag = 1;
                            end
                        end
                    elseif (n(z) > 1)
                        min = n(z);
                        if z >= 5
                           diag = 1;
                        end
                    end            
                end

                if(min > 1 && min <= min_now)
                    if diag == 1
                        obsMap(r, c) = min + 1.41;  %diagonal movement
                    else
                        obsMap(r,c) = min + 1;  %horizontal or vertical movement
                    end
                    checked = 1; %flag that indicates that at least one cell has been updated
                end
            end
        end
    end

    % These are the 8 orientations that a vector can have
    dir = zeros(1, 8);
    dir(1) = pi;
    dir(2) = 3*pi/2;
    dir(3) = pi/2;
    dir(4) = 0;
    dir(5) = (1/4)*pi;
    dir(6) = (3/4)*pi;
    dir(7) = (5/4)*pi;
    dir(8) = (7/4)*pi;
    
    maxi = max(max(obsMap));
    for c = 1:ncols
        for r = 1:nrows
            if(obsMap(r,c) == 1) % obstacles cells are 1, geo-fence cells are 2, so the value of a free space cell is at least 3
                obsMap(r, c) = maxi + 5;
            elseif(obsMap(r, c) == -1) % obstacles cells are 1, geo-fence cells are 2, so the value of a free space cell is at least 3
                obsMap(r, c) = maxi + 1;
            end
        end
    end
    
    % In the following loop the vector field map is built. For each cell
    % the orientation is selected so that the vector points towards the
    % neighboring cell having the lowest value.
    for c = 1:ncols
        for r = 1:nrows
            if(obsMap(r, c) <= 2) % obstacles cells are 1, geo-fence cells are 2, so the value of a free space cell is at least 3
                continue;
            end

            % find the lowest value among the neighboring cells
            n(1:8) = -1;

            if(c > 1)
                n(1) = obsMap(r, c - 1);
            end

            if(r > 1)
                n(2) = obsMap(r - 1, c);
            end

            if(r < nrows)
                n(3) = obsMap(r + 1, c);
            end

            if(c < ncols)
                n(4) = obsMap(r, c + 1);
            end

            if(r < nrows && c < ncols)
                n(5) = obsMap(r + 1, c + 1);
            end

            if(c > 1 && r < nrows)
                n(6) = obsMap(r + 1, c - 1);
            end

            if(c > 1 && r > 1)
                n(7) = obsMap(r - 1, c - 1);
            end

            if(c < ncols && r > 1)
                n(8) = obsMap(r - 1, c + 1);
            end

            min = -1;      
            
            % set the orientation of the vector field
            for z = 1:8
                if(min > 0 && n(z) > 1)
                    if(n(z) < min)
                        min = n(z);
                        map_wavefront(r, c) = dir(z);
                    end
                elseif(n(z) > 1)
                    min = n(z);
                    map_wavefront(r, c) = dir(z);
                end
            end
        end
    end
    cost_map = obsMap;
