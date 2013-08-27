function [ viewtime ] = lis_hdf_viewtime( filename )
%LIS_HDF_VIEWTIME imports LIS hdf files and extracts the viewtime coverage area
%	viewtime gives: [startDate, endDate, effectiveTime (s), gridCell]
%
%   Written By:  Michael Hutchins

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

	% UTC is behind TAI by 34 seconds in 2011, 35 seconds after 2012/6/30
	% UTC is behind TAI93 by 7 seconds in 2011, 8 seconds after 2012/6/30

	% Check for UTC-TAI93 difference

	checkDate = (time ./86400) + datenum([1993,1,1]);

	if mode(floor(checkDate)) >= datenum([2012,06,30])
		TAI_UTC = 8;
	else
		TAI_UTC = 7;
	end

	time = (time - TAI_UTC) ./ 86400;

	date = time + datenum([1993,1,1]);

end