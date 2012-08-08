%Export data to file
function power_export(data,filename)


fid=fopen(filename,'wt');
for i=1:size(data,1);
   
fprintf(fid,'%g/%g/%g,%02g:%02g:%09f, % 08.4f, % 09.4f,% 05.1f, %g, %.2f %.2f %g\n',data(i,1:13));

end
fclose(fid);