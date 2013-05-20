%Export data_power to file
%
%   Written By:  Michael Hutchins

function power_export(data,filename)


fid=fopen(filename,'wt');
for i=1:size(data,1);
   
fprintf(fid,'%g/%g/%g,%02g:%02g:%09f, % 08.4f, % 09.4f,% 05.1f, %g, %f, %f\n',data(i,1:12));

end
fclose(fid)