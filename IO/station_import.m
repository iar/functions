function [station_loc,station_name] = station_import(filename)
%station_import Imports stations.dat file to stations.mat
    fid=fopen(filename);
    fend=feof(fid);
    s=fgets(fid);
    index=1;
    while fend==0
       [A,a1,a2,next_index]=sscanf(s,'%g %g');
       %Prevents Nanjing from registering as NaN jing
       if length(A)>2 
           A=A(1:2);
           next_index=next_index-3;
       end
       
       B=sscanf(s(next_index:end),' %s');
       station_loc(index,:)=A';
       station_name{index,:}=B; 
       fend=feof(fid);
       s=fgets(fid);
       index=index+1; 
    end
    fclose all;
end

