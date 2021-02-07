function Pts = getUnstablePoint(PL, PR, WL, WR, L, R, tol)
%GETUNSTABLEPOINTNUMERICAL2 Calculates the location on the line segment 
% [R, L] that equal in distance to |L,PR| + WR and |L,PL| + WL where WR 
% and WL are the shortest distances to the goal from points PR and PL 
% respectively.

    % Calculate length difference at left and right
    lengthL = (norm(L - PL) + WL) - (norm(L - PR) + WR);
    lengthR = (norm(R - PL) + WL) - (norm(R - PR) + WR);
    
    % SCENARIOS 1 - 3 can be determined without knowledge of the slope.
    
    % SCENARIO 1: UNSTABLE POINT AT L
    if abs(lengthL) == 0
        Pts = L;
        return;
    end
    
    % SCENARIO 2: UNSTABLE POINT AT R
    if abs(lengthR) == 0
        Pts = R;
        return;
    end
    
    % SCENARIO 3/4: EXACTLY ONE UNSTABLE POINT LOCATED BETWEEN L AND R
    if sign(lengthL) ~= sign(lengthR)
        mid = (L + R)/2;
        if abs(lengthL) < tol && abs(lengthR) < tol
            % SCENARIO 3: UNSTABLE POINT LOCATED HALFWAY BETWEEN L AND R
            Pts = mid;
        else
            % SCENARIO 4: UNSTABLE POINT LOCATED SOMEWHERE BETWEEN L AND R
            Pts = unique(...
                [getUnstablePoint(PL, PR, WL, WR, mid, L, tol);...
                 getUnstablePoint(PL, PR, WL, WR, R, mid, tol)],...
                 'rows');
        end
        return;
    end
    
    % Calculate slopes
    dir = tol*(R - L)/norm(R - L);
    lengthLDelta = (norm(L + dir - PL) + WL) - (norm(L + dir - PR) + WR);
    lengthRDelta = (norm(R - dir - PL) + WL) - (norm(R - dir - PR) + WR);
    slopeL = (lengthLDelta - lengthL);
    slopeR = (lengthR - lengthRDelta);
    
    % SCENARIOS 5 - REQUIRE KNOWLEDGE OF THE SLOPE
    
    % SCENARIO 5: If the points have the same slope, then the current
    % lengths will always be the same. Therefore, there is no unstable
    % point.
    if abs(slopeL - slopeR) < tol
        Pts = [];
        return;
    end
    
    % SCENARIO 6: NO UNSTABLE POINTS BETWEEN L AND R
    if sign(slopeL) == sign(lengthL)
        Pts = [];
        return;
    end
    

    if sign(slopeL) == sign(slopeR)
        % SCENARIO 7: NO UNSTABLE POINTS BETWEEN L AND R
        Pts = [];
        return;
    else
        if abs(lengthL) < tol && abs(lengthR) < tol
            % SCENARIO 8: NO UNSTABLE POINTS BETWEEN L AND R
            Pts = [];
        else
            % SCENARIO 9: UNCERTAIN IF UNSTABLE POINT BETWEEN L AND R
            mid = (L + R)/2;
            Pts = unique(...
                [getUnstablePoint(PL, PR, WL, WR, mid, L, tol);...
                 getUnstablePoint(PL, PR, WL, WR, R, mid, tol)],...
                 'rows');
        end
        return;
    end
end