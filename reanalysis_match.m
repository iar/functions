function [ weather ] = reanalysis_match( lat, long, date )
%REANALYSIS_MATCH returns the NARR weather data at LAT, LONG, DATE
%
%	Written by: Michael Hutchins

[ air, shum, level, grid ] = narr_import( date );

end

