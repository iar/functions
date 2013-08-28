function [ landStatus ] = land_check( lat, long )
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

end

