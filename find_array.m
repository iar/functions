function [ location ] = find_array( value, array )
%FIND_ARRAY finds the index location of VALUE in ARRAY for 2D arrays.

    near = min(abs(array(:) - value));
    nearest = array(abs(array(:) - value) == near);

    index = find(array == nearest);
    
    location(2) = ceil(index/size(array,1));
    location(1) = mod(index,size(array,1));
    
end

