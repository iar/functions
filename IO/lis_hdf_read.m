function [ flashes, viewtime ] = lis_hdf_read( filename )
%LIS_HDF_READ imports LIS hdf files and extracts flash data
%
%   Written By:  Michael Hutchins

	%% Flashes

	flash = hdfread(filename,'flash');

	time = double(flash{1}');
	duration = double(flash{2}');
	viewtime = double(flash{3}');
	location = double(flash{4}');
	radiance = double(flash{5}');
	area = double(flash{6}');
	groups = double(flash{10}');
	events = double(flash{11}');
	confidence = double(flash{14}');

	date = TAI93ToUTC(time);

	flashes = ([datevec(date),location,events,confidence,radiance,area,duration]);

	%% Viewtime
	
	viewtime = hdfread(filename,'viewtime');

	gridCell = double(viewtime{1}');
	startTime = double(viewtime{2}');
	endTime = double(viewtime{3}');
	effectiveTime = double(viewtime{4}');

	startDate = TAI93ToUTC(startTime);
	endDate   = TAI93ToUTC(endTime);

	viewtime = ([startDate,endDate,effectiveTime,gridCell]);

end

function [date] = TAI93ToUTC( time )
%TAI93ToUTC converts the TAI93 TIME to matlab DATENUM format in UTC
% UTC is behind TAI by 34 seconds in 2011, 35 seconds after 2012/6/30
% UTC is behind TAI93 by 7 seconds in 2011, 8 seconds after 2012/6/30
%
%	Written By: Michael Hutchins

	% Check for UTC-TAI93 difference
	checkDate = (time ./86400) + datenum([1993,1,1]);

	if mode(floor(checkDate)) >= datenum([2012,06,30])
		TAI_UTC = 8;
	else
		TAI_UTC = 7;
	end

	% Convert time
	time = (time - TAI_UTC) ./ 86400;

	date = time + datenum([1993,1,1]);

end