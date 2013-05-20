%Export data to file
function wwlln_export(data,filename)
%
%   Written By:  Michael Hutchins


fid=fopen(filename,'wt');
format='%g/%g/%g,%02g:%02g:%09f, % 08.4f, % 09.4f,% 05.1f, %g, %.2f %.2f %g\n';
if size(data,2)~=13
    format=sprintf('%%g/%%g/%%g,%%02g:%%02g:%%09f, %% 08.4f, %% 09.4f,%% 05.1f, %%g%s\n',...
        repmat(', %.2f',1,size(data,2)-10));
end

for i=1:size(data,1);
      
fprintf(fid,format,data(i,:));

end
fclose(fid);