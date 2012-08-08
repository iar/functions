function [ndata]=map_bin(data,varargin)
%MAP_BIN takes WWLLN formatted data and returns the location data in one
%degree by one degree density maps
%   Options:
%         'Resolution',resolution - Overides default resolution (in degrees)
        
%   2011/10/17 - Created - Michael Hutchins

    Options=varargin;
    res=1; 
    
    %strcmp(Options)
    for i=1:length(Options)
        if strncmp(Options{i},'Resolution',4)
            res=Options{i+1};
        end
    end
    
    data_plot = [data(:,8),data(:,7)]; %switches lat and long
    centers = {-180+res/2:res:180-res/2,-90+res/2:res:90-res/2};
    [ndata,c] = hist3(data_plot,'Ctrs',centers);% Extract histogram data
    ndata=ndata';
end