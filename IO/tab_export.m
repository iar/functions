function tab_export(filename,data,format)
%tab_export(filename,data)
    %exports data into a the tab delimited filename. 
    %Michael Hutchins - 9/12/11 
	
	switch nargin
		case 2
			dataType = '%f\t';
		case 3
			if strcmp(format,'float')
				dataType = '%f\t';
			elseif strcmp(format,'int')
				dataType = '%d\t';
			elseif strcmp(format,'double')
				dataType = '%g\t';
			else
				error('Unknown format: float, int, or double')
			end
	end
	
    
    columns=size(data,2);
    fid=fopen(filename,'wt');
    for i=1:size(data,1);
        fprintf(fid,sprintf('%s\n',repmat(dataType,1,columns)),data(i,:));
    end
    fclose(fid);
end

