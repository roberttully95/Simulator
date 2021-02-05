function items = sequenceWrap(i1, i2)
    %SEQUENCE Generates a sequence of numbers from i1 to i2 that wraps back
    %around. 
    % For example, for i1 = 1, i2 = 3 the generated list is [1, 2; 2, 3; 3,
    % 1];
    items = [(i1:i2)', circshift((i1:i2)', -1)];
end
