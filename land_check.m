function [ landStatus, zStatus ] = land_check( lat, long )
%LAND_CHECK loads ETOPO data and returns 1 for each lat/long point above
%land and 0 for each point above water.
%
%	Written By: Michael Hutchins

%% Use ETOPO data to define land and ocean grid cells
%   Resolution set to be 1 degree

	z = load_etopo; 

    zRes = size(z,1)/180;

    z = circshift(z,[0 size(z,2)/2]);

    
    for i = 1 : zRes
        if i == 1
            z1 = z(i:zRes:end,i:zRes:end);
        else
            z1 = z1 + z(i:zRes:end,i:zRes:end);
        end
    end

    z = z1./zRes;

    land = z>0;

	
%% Format Lat/Long

	if nargin == 1 && any(size(lat) == 2)
		if size(lat,1) == 2
			long = lat(2,:);
			lat = lat(1,:);
		else
			long = lat(:,2);
			lat = lat(:,1);
		end
	end

	lat = lat(:);
	long = long(:);

	if length(lat) ~= length(long)
		error('Latitude and Longitude must be the same length.')
	end
	
	% Input check:
	if any(abs(lat) > 90)
		warning('Input latitudes must be between -90 and 90 degrees, inclusive.  Latitude will be bound.')
		lat(lat >  90) =  90;
		lat(lat < -90) = -90;
	end
	
	if any(abs(long) > 180)
		long = wrapTo180(long);
	end

	
%% Check land/ocean location
	
	% Normalize to matlab index (1:360 vs -180:180)
    z_lat=floor(lat(:)+90 + 1/2);
    z_long=floor(long(:)+180 + 1/2);

    z_lat(z_lat==0)=1;
    z_long(z_long==0)=1;

    % Get index of stroke path for 180x360 grid
    loc = sub2ind(size(land),z_lat,z_long);

	% Get path land status
    landStatus = land(loc);
	
%% Get altitude

	zStatus = z(loc);

end

