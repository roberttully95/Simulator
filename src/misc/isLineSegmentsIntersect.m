% ************************************************************************
% File Name   : isLineSegmentsIntersect.m
%               (function m-file)
% Author      : Necati KARTAL
% Date        : 15.01.2015
% Description : This m-file will check if two line segments intersect. 
%               To desing solution, there is using algorithm from 
%               "Intersection of two lines in three-space" by
%               Ronald Goldman.
%               Input : 4 Inputs; First two inputs are two points of first
%                       line as p1,q1 and second two inputs are two 
%                       points of second line as p2,q2.
%               Output: Return 1 if lines are intersect or return 0 if 
%                       lines are not intersect.
% ************************************************************************
function result = isLineSegmentsIntersect(p1, q1, p2, q2)

    r = q1 - p1;
    s = q2 - p2;

    numerator = cross2d(p2 - p1, r);
    denominator = cross2d(r, s);

    % Check collinear situation.
    if numerator == 0 && denominator == 0

        % Check equal vertex if its exist or not.
        if isequal(p1, p2) || isequal(p1, q2) || isequal(q1, p2) || isequal(q1, q2)
            result = 1;
            return;
        end

        % Check overlap situation.
        if ((p2(1,1) - p1(1,1) < 0) ~= (p2(1,1) - q1(1,1) < 0) ~= (q2(1,1) - p1(1,1) < 0) ~= (q2(1,1) - q1(1,1) < 0)) || ((p2(1,2) - p1(1,2) < 0) ~= (p2(1,2) - q1(1,2) < 0) ~= (q2(1,2) - p1(1,2) < 0) ~= (q2(1,2) - q1(1,2) < 0))
            result = 1;
        else
            result = 0;
        end
        return;
    end

    % Check paralel situation.
    if denominator == 0
        result = 0;
        return;
    end

    u = numerator / denominator;
    t = cross2d(p2 - p1, s) / denominator;

    % Check meeting vertex.
    if (t >= 0) && (t <= 1) && (u >= 0) && (u <= 1)
        result = 1;
    else
        result = 0;
    end
end