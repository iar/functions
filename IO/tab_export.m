function tab_export(filename,data)
%tab_export(filename,data)
    %exports data into a the tab delimited filename. 
    %Michael Hutchins - 9/12/11 
    
    columns=size(data,2);
    fid=fopen(filename,'wt');
    for i=1:size(data,1);
        fprintf(fid,sprintf('%s\n',repmat('%f\t',1,columns)),data(i,:));
    end
    fclose all;
end

