function [data] = entln_import(date)
%Imports an ENTLN .CSV lightning file
%Output is YYYY, MM, DD, hh, mm, ss, lat, long, height (m), stroke type,
%amplitude (A), stroke_solution
%
%   Written By:  Michael Hutchins

%% Filepaths

	subdirectory = 'ENfiles';
	prefix = 'EN';
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
			fileImport = sprintf('%s%s/%s.loc',path,subdirectory,fileName);

			% If found break out of the loop
			if exist(fileLoad,'file') == 2
				filename = fileLoad;
				break;
			end
			
			% If found break out of the loop and set import to true
			if exist(fileImport,'file') == 2
				filename = fileImport;
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
		
		if strmatch(filename(end-3:end),'.csv')
			import = true;
		end
		
	% Error out if not found
	else
		error('Unrecognized filename.')
	end

%% Read/Load data
	
	if import
		%%
		fid = fopen(filename);
		s=fgets(fid);
		fend=feof(fid);
		index=1;
		data=zeros(20000000,14);

		while(fend==0),
			s=fgets(fid);
			
			A = textscan(s,'%s','Delimiter',',');
			A = A{1};
			
			readDate = sscanf(A{5},'%g-%g-%gT%g:%g:%g');
			readLat = sscanf(A{6},'%g');
			readLong = sscanf(A{7},'%g');
			readHeight =  sscanf(A{8},'%g');
			readType =  sscanf(A{9},'%g');
			readAmp =  sscanf(A{10},'%g');
			readNstn =  length(A) - 15;
			readConf =  sscanf(A{end-2},'%g');
			
			if ~isempty(A{11})
				B = textscan(A{11},'%s','Delimiter',';');
				B = B{1};
				readError = sscanf(B{end},'LocationError=%g');
			else
				readError = 0;
			end

			data(index,:)=[readDate(:)', readLat, readLong, readHeight,...
						   readType, readAmp, readConf, readNstn, readError];

			if data(index,2) == 12;
				break
			end
			
			index=index+1;
			fend=feof(fid);
		end

		data=data(1:index - 1,:);

		fclose(fid);
%%
		
	else
		
		load(filename)

	end

end