function [ z ] = load_etopo
%LOAD_ETOPO loads the ETOPO5 data and returns the altitude data z
%
%	Written By: Michael Hutchins

	%% Find ETOPO Data

		fid = fopen('dataPath.dat');
		dataPath = textscan(fid,'%s','Delimiter','\n');
		dataPath = dataPath{1};
		fclose(fid);	
	for i = 1 : size(dataPath,1);
		if exist(sprintf('%sETOPO5.DAT',dataPath{i}),'file')
			etopoPath = dataPath{i};
			break;
		end
	end

	%% Load Data
	
	z = etopo(etopoPath);

end

