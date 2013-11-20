function [seasons, seasonName] = season_array(dateRange)
%SEASONS returns a N x 4 logical array with each column denoting if the
% date in dateRange is in Winter (DJF), Spring (MAM), Summer (JJA),
% or Fall (SON).
%
%	Written by: Michael Hutchins

	dates = datevec(dateRange);
	months = dates(:,2);
	
	seasons = false(length(dateRange),4);
	
	seasons(:,1) = months == 12 |...
				   months <= 2;
	seasons(:,2) = months >= 3 &...
				   months <= 5;
	seasons(:,3) = months >= 6 &...
				   months <= 8;
	seasons(:,4) = months >= 9 &...
				   months <= 11;
			   
    seasonName = {'DJF','MAM','JJA','SON'};
			   
end

