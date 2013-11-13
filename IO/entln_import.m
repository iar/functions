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
		data=zeros(20000000,13);

		while(fend==0),
			s=fgets(fid);
			A = sscanf(s(85:end),'%g/%g/%g %g:%g:%f %2c,%g-%g-%gT%g:%g:%f,%g,%g,%g,%g,%g');
			if isempty(A) || length(A)~=11
				a=strfind(s,',');
				A = sscanf(s(a(3)+1:end),'%g/%g/%g %g:%g:%f %2c,%g-%g-%gT%g:%g:%f,%g,%g,%g,%g,%g');
			end

			B = textscan(s,'%s%s','Delimiter',',,');
			B1 = B{1};
			B2 = B{2};
			B1 = B1{end-1};
			B2 = B2{end-1};
			if length(B1) < length(B2) && length(B1)>=1
				B = B1;
				Balt = B2;
			else
				B = B2;
				Balt = B1;
			end
			B = sscanf(B,'%g');
			if isempty(B)
				B = sscanf(Balt,'%g');
			end


			D=strfind(s,',,');
			E=strfind(s,'=');

			if length(D)>1
				nstn=length(E);
			else
				nstn=length(E)-2;
			end

			try 
				data(index,:)=[A(9:19)',B,nstn];
			catch
				data(index,:)=[A(3:13)',B,nstn];
			end

			index=index+1;
			fend=feof(fid);
		end

		data=data(1:index-1,:);

		fclose(fid);

		
	else
		
		load(filename)

	end

end