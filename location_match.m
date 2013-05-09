function [ match ] = location_match( lat, long, latTable, longTable )
%LOCATION_MATCH finds the indices in latTable/longTable that matches the
%given lat/long values. 
% If a match cannot be found within the initial tolerance it is repeated
% with the tolerance doubling each time.
% If multiple matches are found the mode of the result is used as the
% output
% Note: only use with smoothly varying tables

    match = zeros(length(lat),2);

    tableSize = size(latTable);

    latTable = latTable(:);
    longTable = longTable(:);

    for i = 1 : length(lat);

        tolerance = 0.05;
        location = [];

        while isempty(location)

            loc = abs(latTable - lat(i)) < tolerance;
            loc = loc & abs(longTable - long(i)) < tolerance;

            [I, J] = ind2sub(tableSize,find(loc));  
            location = [I,J]; 

            tolerance = 2 * tolerance;

        end

        if size(location,1) > 1
            location = mode(location);
        end
        
        match(i,:) = location;
        
    end
    
end

