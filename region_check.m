function [ regionID, regionName ] = region_check( lat, long )
%REGION_CHECK retuens the regionID for the points lat, long.
%   Regions defined as:
%		# - Name -- Bounds (lat, long)
%		1 - North America -- [[15 90],  [-130 -60]]
%		2 - South America -- [[-90 15], [-95 -30]]
%		3 - Europe		  -- [[30 90],  [-15 45]]
%		4 - Africa		  -- [[-90 30], [-31 60]]
%		5 - India		  -- [[-10 45],   [61 100]]
%		6 - Asia		  -- [[15 90],  [101 160]]
%		7 - Maritime	  -- [[-90 15], [96 180]]
%
%	Written by: Michael Hutchins

%% Define regions

	regions = zeros(181,361);
	
	regions([15 : 90]  + 91, [-130 : -60] + 181) = 1;
	regions([-90 : 15] + 91, [-95 : -30]  + 181) = 2;
	regions([30 : 90]  + 91, [-15 : 45]   + 181) = 3;
	regions([-90 : 30] + 91, [-31 : 61]   + 181) = 4;
	regions([-10 : 45] + 91, [60 : 100]   + 181) = 5;
	regions([15 : 90]  + 91, [101 : 160]  + 181) = 6;
	regions([-90 : 15] + 91, [96 : 180]  + 181) = 7;
		
	regionName{1} = 'North America';
	regionName{2} = 'South America';
	regionName{3} = 'Europe';
	regionName{4} = 'Africa';
	regionName{5} = 'India';
	regionName{6} = 'Asia';
	regionName{7} = 'Maritime';

%% Format Lat/Long

	lat = lat(:);
	long = long(:);

	if length(lat) ~= length(long)
		error('Latitude and Longitude must be the same length.')
	end
	
	% Input check:
	if any(abs(lat) > 90)
		error('Input latitudes must be between -90 and 90 degrees, inclusive.')
	end
	
	if any(abs(long) > 180)
		long = wrapTo180(long);
	end


%% Check land/ocean location
	
	% Normalize to matlab index (1:360 vs -180:180)
    lat  = floor(lat + 90 + 1/2);
    long = floor(long + 180 + 1/2);

    lat(lat == 0) = 1;
    long(long == 0) = 1;

    % Get index of stroke path for 180x360 grid
    loc = sub2ind(size(regions), lat, long);

%% Get regionIDs

    regionID = regions(loc);

end

