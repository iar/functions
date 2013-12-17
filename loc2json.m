function loc2json( data, exportName )
%Exports DATA as an EXPORTNAME.JSON formatted file
%
%   Written By:  Michael Hutchins


	fid = fopen(sprintf('%s.json',exportName),'wt');
	fprintf(fid,'{\n');

	for i = 1 : size(data,1);

		stroke = data(i,:);
		
		strokeID = 1e7*rand();
		unixTime = datenum(stroke(1:6)) - datenum(1970,1,1);
		unixTime = unixTime * 86400;
		
		fprintf(fid,'\t"%.0f" : {',strokeID);
		fprintf(fid,'"unixTime" : %.1f,\n',unixTime);
		fprintf(fid,'\t\t"lat" : %.2f,\n',stroke(7));
		fprintf(fid,'\t\t"long" : %.2f}',stroke(8));

		if i == size(data,1);
			fprintf(fid,'\n');
		else
			fprintf(fid,',\n');
		end
		
		
	end

	fprintf(fid,'}');
	

end

