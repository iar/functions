function [lookup,div,station]=lookup_import(filename)
%lookup_import Loads the lookup text file
    fid=fopen(filename);
    fend=feof(fid);
    s=fgets(fid);
    index=1;
    index_stat=1;
    
    while fend==0
       A=sscanf(s,'%g\t');
       if isempty(A) | isnan(A); 
           A=sscanf(s,'%s %g %g');
           if isempty(A)
               index_stat=index_stat+1;
               index=1;
           else
               station.loc(index_stat,:) = A(end-1:end);
               station.name{index_stat} = char(A(1:end-2))';
           end
       else
           lookup(index,:,index_stat)=A;
           index=index+1; 
       end
       fend=feof(fid);
       s=fgets(fid);
    end
    fclose all;
    div=360/size(lookup,1);
end





% Write Lookup file
% 
% fid=fopen('lookup_night.dat','wt');
% for j=1:size(lookup_night,3);
%     for i=1:size(lookup_night,1);
%         fprintf(fid,'%g\t',lookup_night(i,:,j));
%         fprintf(fid,'\n');
%     end
%     fprintf(fid,'\n');
% end
        