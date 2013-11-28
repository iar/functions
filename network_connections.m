function [ tracks ] = network_connections( wwlln, apdata, nlegs )
%NETWORK_CONNECTIONS returns the great circle paths connecting strokes to
%	their locating stations.
%
%	Written by: Michael Hutchins

%% Initialize tracks and load station data

	tracks = [NaN, NaN];
	stations	
	
	switch nargin
		case 2
			nlegs = 10;% number of segments per path
	end
	
%% Strip away SCU units from apdata

	apdata = apdata(:,1:2:end);
	
%% Convert empty entries to NaN

	apdata(apdata == 0) = NaN;
	apdata(isnan(apdata(:,1))) = 0;

%% Convert to lat/long array
	
	strokeLat  = repmat(wwlln(:,7),1,size(apdata,2));
	strokeLong = repmat(wwlln(:,8),1,size(apdata,2));
	
	strokeLat = strokeLat(:);
	strokeLong = strokeLong(:);
	
	stationID = apdata(:);
	
	nanLoc = isnan(stationID);
	
	stationID(nanLoc) = [];
	strokeLat(nanLoc) = [];
	strokeLong(nanLoc) = [];
	
	stationLat = station_loc(stationID + 1,1);
	stationLong = station_loc(stationID + 1,2);
	
	path = [strokeLat,strokeLong,stationLat,stationLong];

%% Go through each station - stroke pair

	for i = 1 : size(path,1);
		
		track = gcwaypts(path(i,1),path(i,2),path(i,3),path(i,4),nlegs);
		
		tracks = [tracks;track;[NaN NaN]];
		
	end

%% Add in NaN for tracks crossing the poles or -180 -> 180

	tracks = insertrows(tracks,[NaN NaN],find(tracks(:,1) > 80 | tracks(:,1) < -80));
	tracks = insertrows(tracks,[NaN NaN],find([abs(diff(tracks(:,2))) > 100]));

end

