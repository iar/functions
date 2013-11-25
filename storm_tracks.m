function [ tracks ] = storm_tracks( storms, data )
%STORM_TRACKS returns the path of the STORMS mean location every 5 minutes
%
%	Written by: Michael Hutchins

	% Remove noise events

	data(storms == 0,:) = [];
	storms(storms == 0,:) = [];
	minCounts = 10;
	
	% Get list of storms
	
	stormList = unique(storms(:));
	
	% Initialize tracks
	
	tracks = [NaN, NaN];
	
	for i = 1 : length(stormList);
		
		storm = data(storms == stormList(i),:);
		
		if isempty(storm)
			continue
		end
		
		if size(storm,1) < minCounts
			continue
		end
		
		track = get_track(storm);
		
		tracks = [track;tracks];
		
	end

end

function [track] = get_track(data)

	trackStep = 5; % minutes
	
	stormMinutes = datenum(data(:,1:6)) - min(datenum(data(:,1:6)));
	stormMinutes = stormMinutes * 24 * 60;
	stormMinutes = ceil(stormMinutes / trackStep);
	stormMinutes(stormMinutes == 0) = 1;
	
	steps = max(stormMinutes);

	track = NaN(1,2);
	
	if steps <= 1
		return
	end
	
	for i = 1 : steps;
		
		loc = stormMinutes == i;
		
		if range(data(loc,8)) > 100;
			long = median(wrapTo360(data(loc,8)));
			long = wrapTo180(long);
		else
			long = median(data(loc,8));
		end
			
		lat = median(data(loc,7));

		if ~isempty(lat) && ~isempty(long)
		
			track = [track;[lat,long]];
			
		end
	end
		
	
end
