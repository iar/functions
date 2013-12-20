function station2json( station_loc, station_name, vlf_url, exportName )
%Exports DATA as an EXPORTNAME.JSON formatted file
%
%   Written By:  Michael Hutchins


	fid = fopen(sprintf('%s.json',exportName),'wt');
	fprintf(fid,'{\n');

	for i = 1 : size(station_loc,1);

		station = station_loc(i,:);
		
		id = station_name{i};

		vlf = vlf_url{i};
		
		fprintf(fid,'\t"%s" : {',id);
		fprintf(fid,'"lat" : %.3f,\n',station(1));
		fprintf(fid,'\t\t"long" : %.3f,\n',station(2));
		fprintf(fid,'\t\t"vlf" : "%s",\n',vlf);
		fprintf(fid,'\t\t"name" : "%s"}',id);

		if i == size(station_loc,1);
			fprintf(fid,'\n');
		else
			fprintf(fid,',\n');
		end
		
		
	end

	fprintf(fid,'}');
	

end

