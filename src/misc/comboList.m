function list = comboList(n)
%COMBOLIST Given an upper bound, creates a list of all possible non self-intersecting edges
%between points.

    list = NaN((n * (n - 1)) / 2, 2);
    iCurr = 1;
    for i = 1:n
        for j = 1:n
            if i < j
                list(iCurr, :) = [i, j];
                iCurr = iCurr + 1;
            end
        end
    end
end

