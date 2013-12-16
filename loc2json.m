function loc2json( data, exportName )
%Exports DATA as an EXPORTNAME.JSON formatted file
%
%   Written By:  Michael Hutchins


	fid = fopen(sprintf('%s.json',exportName),'wt');
	fprintf(fid,'{\n');

	for i = 1 : size(data,1);

		stroke = data(i,:);
		
		strokeID = i;
		info = sprintf('%s-%g',exportName,i);
		unixTime = datenum(stroke(1:6)) - datenum(1970,1,1);
		unixTime = unixTime * 86400;
		
		fprintf(fid,'\t"%i" : {',strokeID);
		fprintf(fid,'"info" : "%s",\n',info);
		fprintf(fid,'\t\t"date" : "%g/%g/%g",\n',stroke(1:3));
		fprintf(fid,'\t\t"time" : "%g:%g:%.1f UTC",\n',stroke(4:6));
		fprintf(fid,'\t\t"unixTime" : %.1f,\n',unixTime);
		fprintf(fid,'\t\t"lat" : %.2f,\n',stroke(7));
		fprintf(fid,'\t\t"long" : %.2f,\n',stroke(8));
		fprintf(fid,'\t\t"energy" : %.0f}',stroke(11));

		if i == size(data,1);
			fprintf(fid,'\n');
		else
			fprintf(fid,',\n');
		end
		
		
	end

	fprintf(fid,'}');
	

end

