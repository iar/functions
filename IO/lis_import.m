function [flashes, viewtime, groups] = lis_import(date)
%Imports a LIS data file:
%   YYYY,MM,DD,hh,mm,ss,lat,long,evnts,confidence,irradiance,area,duration
%	LIS files generated with lis_hdf_read.m
%
%   Written By:  Michael Hutchins

%% Check for date specified file
	if strncmp(class(date),'double',6)

		% Format date into datevec format
		if length(date) == 1;
			date=datevec(date);
			date=date(1:3);
		elseif length(date)~=3
			warning('Unknown Input Format');
		end

		% Generate filename
		fileName=sprintf('lis%04g%02g%02g.mat',date(1:3)); 

		% Load dataPath.dat file
		dataPath = textread('dataPath.dat','%s\n');

		% Check each path for the file
		for i = 1 : size(dataPath,1);
			
			% Generate load name to check
			path = dataPath{i};
			fileLoad = sprintf('%sLIS/%s',path,fileName);
			
			% If found break out of the loop
			if exist(fileLoad,'file') == 2
				filename = fileLoad;
				break;
			end
			
			% If loop ends without finding give error
			if i == size(dataPath,1)
				error(sprintf('File %s not found!',fileName));
			end
		end

%% Check for filename specified file
	elseif strmatch(class(date),'char')
		filename=date;
%% Error out if not found
	else
		error('Unrecognized filename.')
	end

%% Load file
	load(filename);

end
