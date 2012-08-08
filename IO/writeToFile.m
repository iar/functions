function writeToFile(filename,variable,save_name,format)
%writeToFile loads a variable from a .mat file and write it to the
%   specified output using the given format
%   (filename,variable,save_name,format) are all strings

%   by: Michael Hutchins
%   last update 3/16/2011


load(filename,variable);
eval(sprintf('data=%s;',variable))
fid=fopen(save_name,'wt');
for i=1:size(data,1);
    fprintf(fid,sprintf('%s\n',format),data(i,:));
end
fclose(fid); 
end