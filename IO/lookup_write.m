function lookup_write( lookup, filename, station_name, station_loc )
%
%   Written By:  Michael Hutchins

    fid=fopen(filename,'wt');
    for j=startIndex:size(lookup,3);
        fprintf(fid,'%s\t%g\t%g\n',station_name{j},station_loc(j,:));
        for i=1:size(lookup,1);
            fprintf(fid,'%g\t',lookup(i,:,j));
            fprintf(fid,'\n');
        end
        fprintf(fid,'\n');
    end

end

