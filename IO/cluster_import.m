function [ cluster ] = cluster_import( date )
%CLUSTER_IMPORT gives the cluster ID for the WWLLN AE file given by date
%   Clusters are determined by cluster_wwlln.m
%
%   Written By:  Michael Hutchins
 

%% Filepaths

	subdirectory = 'clusterFiles/';
	prefix = 'cluster';
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
	 	fclose(fid);
	
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
   
		% Load tree data

		data = ae_import(date);
		cluster = cluster_wwlln(data);
		
		% Save traversed tree data
		saveName = sprintf('%s%s%04g%02g%02g%s',fileDir,prefix,date,suffix);
		save(saveName, 'cluster');
		

	else
		load(filename);
        
    end
    
end

