function [ weather ] = reanalysis_match( lat, long, date )
%REANALYSIS_MATCH returns the NARR weather data at LAT, LONG, DATE
%	Weather gives [air temperature, specific humidity]	
%
%	Written by: Michael Hutchins

%% Parameters

	maxLevel = 850; %hPa pressure level for reanalysis data

%% Format Date

	% Format date into datevec format
	if size(date,2) == 1;
		date = datevec(date);
		hour = date(:,4);
		date = median(date(:,1:3));
	elseif size(date,2) == 6
		hour = date(:,4);
		date = median(date(:,1:3));
	elseif size(date,2) == 3
		date = median(date(:,1:3));
		hour = zeros(size(date,1),1);
	else
		warning('Unknown Input Format');
	end

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

%% Initialize Output

	weather = zeros(length(lat), 2);

%% Import NARR Data
	
	[ air, shum, level, grid ] = narr_import( date );
	
	% Extract NARR lat and long data
    narrLat = grid.lat;
    narrLong = grid.long;
	
	% Get max pressure level index
	maxLevel = find(level == maxLevel);
	
	% Set hour index
	hour = floor(hour/3) + 1;

	% Compress air and shum data
	temp = squeeze(mean(air(:,:,1:maxLevel,:),3));
	humidity = squeeze(mean(shum(:,:,1:maxLevel,:),3));
	
%% Get from lat and long to grid

	% Get narrCenter index closest to lat and long
	narrCenter = location_match(lat,long,narrLat,narrLong);

	% Initialize temporary parfor vectors
	parTemp = nan(size(narrCenter,1),1);
	parShum = parTemp;

	% Get weather data gfor each data point
	parfor i = 1 : size(narrCenter,1)
		I = narrCenter(i,1);
		J = narrCenter(i,2);

		if ~isnan(I)
			parTemp(i) = temp(I,J,hour(i));
			parShum(i) = humidity(I,J,hour(i));
		end
	end

%% Set weather outputs
	
	weather(:,1) = parTemp;
	weather(:,2) = parShum;

end

