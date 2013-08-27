function [station_loc,station_name] = station_entln(filename)
%station_import Imports ENTLN stations.dat file
%
%   Written By:  Michael Hutchins

    fid=fopen(filename);
    fend=feof(fid);
    s=fgets(fid);
    index=1;
    while fend==0
       [A]=sscanf(s,'%c%c%c%c%c %g %g');
       
       station_loc(index,:)=[A(6),A(7)];
       station_name{index,:}=char(A(1:5)');
       fend=feof(fid);
       s=fgets(fid);
       index=index+1; 
    end
    fclose(fid);
end

