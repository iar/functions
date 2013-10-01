function [ air, shum, level, grid ] = narr_import( date )
%NARR_LOAD Loads NARR Reanalysis date, downloads if not available locally
%   Read in netCDF date from Reanalysis
%   Using NARR Reanalysis 3-hour date: http://www.esrl.noaa.gov/psd/date/gridded/date.narr.html
%   ftp://ftp.cdc.noaa.gov/datesets/NARR/pressure/
%
%   Written By:  Michael Hutchins
 

%% Filepaths

	subdirectory = 'NARRfiles';
	prefix = 'NARR';
	suffix = '';

%% Initialize variables

	import = false;

%% Check for date specified file

	if strncmp(class(date),'double',6)

		% Format date into datevec format
		if length(date) == 1;
			date=datevec(date);
			date=date(1:3);
		elseif length(date) == 6
			date = date(1:3);
		elseif length(date)~=3
			warning('Unknown Input Format');
		end

		% Generate filename
		fileName=sprintf('%s%04g%02g%02g%s',prefix,date(1:3),suffix); 
		
		% Load dataPath.dat file
		fid = fopen('dataPath.dat');
		dataPath = textscan(fid,'%s','Delimiter','\n');
		dataPath = dataPath{1};
		
		% Check each path for the file
		for i = 1 : size(dataPath,1);
			
			% Generate load name to check
			path = dataPath{i};
			fileLoad = sprintf('%s%s/%s.mat',path,subdirectory,fileName);
			fileDir = sprintf('%s%s',path,subdirectory);

			% If found break out of the loop
			if exist(fileLoad,'file') == 2
				filename = fileLoad;
				break;
			end
			
			% If found break out of the loop and set import to true
			if exist(fileDir,'dir') == 7
				import = true;
				break;
			end			
			% If loop ends without finding give error
			if i == size(dataPath,1)
				error(sprintf('File %s not found!',fileName));
			end
		end

	% Check for filename specified file
	elseif strmatch(class(date),'char')
		filename = date;
		
	% Error out if not found
	else
		error('Unrecognized filename.')
	end



%% Read/Load data
	
	if import
    
    	%% Set raw filenames

			% Air Temperature @ Pressure Levels
			airName = sprintf('%sair.%04g%02g.nc',fileDir,date(1:2));
			% Specific Humidity @ Pressure Levels
			shumName = sprintf('%sshum.%04g%02g.nc',fileDir,date(1:2));

		%% Check for local files or download

			ftpServer = 'ftp://ftp.cdc.noaa.gov/NARR/pressure/';

			currentPath = pwd;

			if exist(airName,'file') ~= 2 
				cd(fileDir);
				system(sprintf('wget %sair.%04g%02g.nc',ftpServer,date(1:2)));
				cd(currentPath);
			end

			if exist(shumName,'file') ~= 2
				cd(fileDir);
				system(sprintf('wget %sshum.%04g%02g.nc',ftpServer,date(1:2)));
				cd(currentPath);
			end

		%% Read Variables

			info = ncinfo(airName);

			variables = {info.Variables.Name};

			for i = 1 : length(variables);
				eval(sprintf('%s = ncread(''%s'',''%s'');',variables{i},airName,variables{i}));
			end

			shum = ncread(shumName,'shum');

			variables{end+1} = 'shum';

			% Time is in hours since 1800/01/01
			time = time./24 + 657438;
    
		%% Resave in daily matlab format

			dates = floor(time);
			dates = unique(dates);

			airTotal = air;
			shumTotal = shum;
			timeTotal = time;

			for i = 1 : length(dates)
				date = datevec(dates(i));
				saveName = sprintf('%s%s%04g%02g%02g.mat',fileDir,prefix,date(1:3));
				air = squeeze(airTotal(:,:,:,floor(timeTotal)==dates(i)));
				shum =  squeeze(shumTotal(:,:,:,floor(timeTotal)==dates(i)));
				time = timeTotal(timeTotal == dates(i));
				save(saveName,variables{:});
			end
	else
		load(filename);
        
    end
    
    %% Format output varaible grid
    
    grid.lat = lat;
    grid.long = lon;
    grid.time = time;
    grid.x = x;
    grid.y = y;

end

