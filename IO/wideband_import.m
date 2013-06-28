function [t, y, Fs] = wideband_import(fileName);
%WIDEBAND_IMPORT imports WWLLN wideband files and returns the time base,
%amplitude, and sampling frequency
%
% Adapted by Michael Hutchins
% Original code by James Brundell

	fid = fopen(fileName);
    
    unixTime = fread(fid,1,'int');  %seconds since 1 Jan 1970
    Fs= fread(fid,1,'double');  %precise sampling rate
    offsetSamples = fread(fid,1,'double');
    y=fread(fid,[1,inf],'short');
    y = y/32768;
    fclose(fid);

    %compute wideband timebase
    t=(0:1:length(y)-1);
    t=t+offsetSamples;
    t = t/Fs;
	
end