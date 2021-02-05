% ************************************************************************
% File Name   : cross2d.m (function m-file)
% Author      : Robert TULLY
% e-mail: rtully95@gmail.com 
% Date        : 01/22/2021
% Description : Calculates the cross product of two 2-dimensional vectors.
%               Input : 
%                   a: The first vector.
%                   b: The second vector.
%               Output: 
%                   Returns the cross product of the input vectors.
% ************************************************************************
function result = cross2d(a, b)

    % Error check
    sza = size(a);
    szb = size(b);
    if ~isequal(sza, szb)
        error("Input vectors must be the same dimensions")
    elseif  ~isequal(sza, [1, 2])
        error("Input vectors must be 2 X 1 row vectors.")
    elseif ~isnumeric(a) || ~isnumeric(b)
        error("Input vectors must contain numeric data.")
    end
    
    result = a(1,1) * b(1,2) - a(1,2) * b(1,1);
end