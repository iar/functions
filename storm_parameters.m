function [ parameters ] = storm_parameters( wwlln, stormID, flashID, minCount, fullParameters )
%STORM_PARAMETERS returns an array PARAMETERS giving summary statistics of
%the storms identified by stormID.
%	fullParameters defaults to true, if false only process parameters 1 - 8
%	
%	parameters:
%		1:3    stormID, startVec, endVec
%		4:8    duration, strokes, area, lat, long, 
%		9:11   5th, 95th energy, median,
%		12:13  stroke rate, interstroke time
%		14:15  land percentage, region,
%		16:17  mean temperature, mean specific humidity
%		18:20  interflash time, flash rate, median flash energy
%		21:22  flash counts, mean multiplicty
%				  
%	Written by: Michael Hutchins

%% Set control parameters

	switch nargin
		case 3
			minCount = 50;
			fullParameters = true;
		case 4
			fullParameters = true;
	end
	
%% Condition WWLLN data

	wwlln(stormID == 0,:) = [];
	stormID(stormID == 0) = [];
	
%% Import paramater data
	
	if fullParameters

		lat = wwlln(:,7);
		long = wwlln(:,8);

		loc = lat > 0 & (long < -50 | long > 160);

		weatherCut = reanalysis_match( lat(loc), long(loc), wwlln(loc,1:6));

		weather = zeros(size(wwlln,1),2);
		weather(loc,:) = weatherCut;

		[land] = land_check(lat, long);
		[regionID, ~] = region_check(lat, long);

	end
	
%% Get storm list

	stormList = unique(stormID);
	
%% Initialize output array

	parameters = nan(length(stormList),22);
	
%% Process each storm

	for i = 1 : length(stormList)
		
		id = stormList(i);
		loc = stormID == id;
		storm = wwlln(loc,:);
		
		% stormID
		parameters(i,1) = id;
		
		% Check for minumum storm size before continuing
		if size(storm,1) <= minCount
			continue
		end
		
		% startVec, endVec
		parameters(i,2) = min(datenum(storm(:,1:6)));
		parameters(i,3) = max(datenum(storm(:,1:6)));
		
		% duration
		parameters(i,4) = (parameters(i,3) - parameters(i,2)) * 24;
		
		% Stroke counts
		parameters(i,5) = size(storm,1);

		% area, ellipticity

		[major, minor]=caliper(storm(:,8),storm(:,7),'Deg');
		major = major / 2;
		minor = minor / 2;
		
		parameters(i,6) = pi * major * minor;
		
		% lat, long
		parameters(i,7) = mean(storm(:,7));
		parameters(i,8) = mean(storm(:,8));
		
		% Check for longitude near -180/180
		if range(storm(:,8)) > 90
			parameters(i,8) = mean(storm(:,8) + 180) - 180;
		end
		
		% Stop processing remaining parameters
		if ~fullParameters
			continue
		end
		
		% Energy
		energyLoc = storm(:,11) > 0;
		parameters(i,9) = prctile(storm(energyLoc,11),5);
		parameters(i,10) = prctile(storm(energyLoc,11),95);
		parameters(i,11) = median(storm(energyLoc,11));

		% Lightning rates
		parameters(i,12) = parameters(i,5) / (parameters(i,4) * 3600);
		
		% Interstroke time
		interstroke = diff(sort(datenum(storm(:,1:6)))) * 24 * 3600;
		parameters(i,13) = nanmedian(interstroke(interstroke > 0));
				
		% Terrain
		parameters(i,14) = mean(land(loc));
		
		% Region
		parameters(i,15) = median(regionID(loc));
		
		% Weather
		parameters(i,16) = nanmean(weather(loc,1));
		parameters(i,17) = nanmean(weather(loc,2));
		
		% Flash pre-processing
		
		flashStorm = flashID(loc);
		flashes = [storm,flashStorm];
		flashes = sortrows(flashes,14);
		
		[flashList, firstFlash, ~] = unique(flashStorm);
		
		firstFlash = flashes(firstFlash,:);
	
		% Interflash time
		interflash = diff(sort(datenum(firstFlash(:,1:6)))) * 24 * 3600;
		parameters(i,18) = nanmedian(interflash(interflash > 0));

		% Flash Rate
		parameters(i,19) = length(flashList) / (parameters(i,4) * 3600);

		% Median Flash Energy
		parameters(i,20) = nanmedian(firstFlash(firstFlash(:,11) > 0, 11));
		
		% Flash Counts
		parameters(i,21) = length(flashList);
		
		% Mean multiplicity
		n = hist(flashStorm,max(flashStorm));
		n = n(n > 0);
		parameters(i,22) = nanmean(n);
	
		
	end
end

