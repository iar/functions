function [ location ] = find_array( value, array )
%FIND_ARRAY finds the index location of VALUE in ARRAY for 2D arrays.

    location = zeros(length(value),2);

    for i = 1 : length(value);

        near = min(abs(array(:) - value));
        nearest = array(abs(array(:) - value) == near);

        index = find(array == nearest);

        location(i,2) = ceil(index/size(array,1));
        location(i,1) = mod(index,size(array,1));

    end
end
