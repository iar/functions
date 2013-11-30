function [ hours ] = estimate( days, time, total )
%ESTIMATE Returns hours left in processing run that has processed
%	DAYS in TIME seconds with TOTAL days in the run

	rate = time / days;
	hours = (total - days) * rate;
	hours = hours ./ 3600;


end

