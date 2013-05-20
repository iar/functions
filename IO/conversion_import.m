function [conversion] = conversion_import(filename)
%CONVERSION_IMPORT Imports the WWLLN station conversion data
%
%   Written By:  Michael Hutchins

fid=fopen(filename);

s=fgets(fid);
fend=feof(fid);
index=1;
conversion=zeros(1000,100);
while(fend==0),
    fend=feof(fid);
    A = sscanf(s,'%g');
    conversion(index,1:length(A))=A';
    index=index+1;
    s=fgets(fid);
end
conversion=conversion(1:index-1,:);
fclose all;

end

