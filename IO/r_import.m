function [RData] = r_import(date)
%Imports an altered A file that includes power information for each station
%
%   Written By:  Michael Hutchins

%% Filepaths

	subdirectory = 'Rfiles';
	prefix = 'R';
	suffix = '';

%% Initialize Variables
	
	import = true;
	
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

		% Load dataPath.dat file
		fid = fopen('dataPath.dat');
		dataPath = textscan(fid,'%s','Delimiter','\n');
		dataPath = dataPath{1};
		
		% Check each path for the file
		for i = 1 : size(dataPath,1);
			
			% Generate load name to check
			path = dataPath{i};

			% If found break out of the loop
			if exist(fileLoad,'dir') == 7
				filePath = path;
				break;
			end
			
			% If loop ends without finding give error
			if i == size(dataPath,1)
				error(sprintf('Path for %s not found!',datestr(date)));
			end
		end

	% Check for filename specified file
	elseif strmatch(class(date),'char')
		
		import = false;
		
	% Error out if not found
	else
		error('Unrecognized filename.')
	end

%% Read/Load data

	if import

		r_path = filePath;

		RData=[0 0 0];

		if datenum(date) <= datenum([2005,7,26])
			for i = 0 : 23
				Date=[date(1:3),i];
				fid=fopen(sprintf('%sr%04g/r%04g%02g/R%04g%02g%02g%02g',r_path,Date(1),Date(1:2),Date(1:4)));

				if fid > -1
					rdata=fscanf(fid,'%g %f',[2,Inf]);
					rdata=rdata';
					fclose(fid);
					rdata=[rdata,zeros(size(rdata,1),1)];

					if size(RData,1)==1
						RData=rdata;
					else
						RData=[RData;rdata];
					end
				else
					fprintf('R%04g%02g%02g%02g Missing\n',Date(1:4));
				end
			end            
		else
			for i=0:10:1440
				Date=datevec(datenum([date(1:3),0,i,0]));
				fid=fopen(sprintf('%sr%04g/r%04g%02g/R%04g%02g%02g%02g%02g',r_path,Date(1),Date(1:2),Date(1:5)));

				if fid > -1

					rdata=fscanf(fid,'%g %f %g',[3,Inf]);
					rdata=rdata';
					fclose(fid);
					if size(RData,1)==1
						RData=rdata;
					else
						RData=[RData;rdata];
					end
				else
					fprintf('R%04g%02g%02g%02g%02g Missing\n',Date(1:5));
				end
			end
		end
    
	else
		
		fid=fopen(date);
		rdata=fscanf(fid,'%g %f %g',[3,Inf]);
		RData=rdata';
		fclose(fid);   
	end

end