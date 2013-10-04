function [ match ] = location_match( lat, long, latTable, longTable )
%LOCATION_MATCH finds the indices in latTable/longTable that matches the
%given lat/long values. 
% If a match cannot be found within the initial tolerance it is repeated
% with the tolerance doubling each time.
% If multiple matches are found the mode of the result is used as the
% output
% Note: only use with smoothly varying tables
%
%   Written By:  Michael Hutchins

    match = zeros(length(lat),2);

    for i = 1 : length(lat);

		dist = abs(latTable - lat(i)) +...
			   abs(longTable - long(i));
		minDist = min(dist(:));

		if minDist < 5;
			[I,J] = find(dist == minDist,1,'first');
			location = [I,J]; 
		else
			location = [NaN, NaN];
		end
        
        match(i,:) = location;
        
    end
    
end

