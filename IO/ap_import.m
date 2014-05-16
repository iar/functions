function [data,power] = ap_import(date)
%Imports an altered A file that includes power information for each station
%
%   Written By:  Michael Hutchins

%% Filepaths

	subdirectory = 'APfiles';
	prefix = 'AP';
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
			fileImport = sprintf('%s%s/%s.loc',path,subdirectory,fileName);

			% If found break out of the loop
			if exist(fileLoad,'file') == 2
				filename = fileLoad;
				break;
			end
			
			% If found break out of the loop and set gz to true
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
		import = true;
		
	% Error out if not found
	else
		error('Unrecognized filename.')
	end

%% Read/Load data
	
	if import
		
		fid = fopen(filename);
		s=fgets(fid);
		fend=feof(fid);
		index=1;
		power=zeros(70,1000000);
		data=zeros(1000000,10);
		% err_index=1;

		while(fend==0),
			if index>1;
				s=fgets(fid);
			end
			[A, count, errmsg, nextindex] = sscanf(s,'%d/%d/%d,%d:%d:%f,%f,%f,%f,%d');
			B = sscanf(s(nextindex+1:end),'%d,%d,');
			power(1:length(B),index)=B;
			if size(A,1)==10;
				data(index,:)=A;
			else
				err_index=err_index+1;
			end
			index=index+1;
			fend=feof(fid);

		end

		data=data(1:index-1,:);
		power=power(:,1:index-1);

		fclose(fid);
		
	else
		
		load(filename)

	end

end
