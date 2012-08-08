function [data] = tab_import(filename,columns)
%tab_import imports tab delimeted file, filename, with columns number of
%   columns. Complements tab_export.m
    %Michael Hutchins - 9/12/11

    switch nargin;
        case 1;
            get_column=true;
        case 2;
            get_column=false;
    end
    
    if get_column
        fid=fopen(filename);
        s=fgets(fid);
        fend=feof(fid);
        [A, count, errmsg, nextindex] = sscanf(s,'%g ');
        
        columns=count;
        
        fclose all;
    end
    
    fid=fopen(filename);
    data=fscanf(fid,repmat('%g ',1,columns),[columns,Inf]);
    data=data';
    fclose all;

end

