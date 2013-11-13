function reporting(reportName,message)
%% REPORTING records the message to console and to the reportFile
%
%	Written by: Michael Hutchins

	fid = fopen(reportName, 'a+');
	
	fprintf(fid,message);
	fprintf(message);
	
	fclose(fid);

end