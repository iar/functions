function [localHour]=utc2loc(time,longitude)
%UTC2LOC(time, longitude) converts the given UTC time to local time based
%	on the given longitude
%
%   Written By:  Michael Hutchins

    time = time(:);
	
    utcHour = time + longitude ./ 15;

    localHour = mod(utcHour, 24);
	
end