function [ data ] = nz_import(filename)
%
%   Written By:  Michael Hutchins

fid=fopen(filename);

data=fscanf(fid,'%d/%d/%d,%d:%d:%f,%f,%f,%f,%d,%g,%g,%g,%g',[14,Inf]);

data=data';

fclose all;

end

