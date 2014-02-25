function [ hours ] = estimate( days, time, total )
%ESTIMATE(completed, time, total) Returns hours left in processing run that
%	COMPLETED segments in TIME seconds with TOTAL sigments in the run
%
%	Written by: Michael Hutchin

	rate = time / days;
	hours = (total - days) * rate;
	hours = hours ./ 3600;


end

