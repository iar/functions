function [data,power] = power_import(filename,local)
%Imports an altered A file that includes power information for each station
%
%   Written By:  Michael Hutchins

switch nargin
    case 1
        local=0;
end

if local==1
    fid=fopen(filename);
else
    fid=fopen(sprintf('../../../../Volumes/Data/WWLLN/AP_files/%s',filename));
end
s=fgets(fid);
fend=feof(fid);
index=1;
power=zeros(70,1000000);
data=zeros(1000000,10);
err_index=1;

while(fend==0),
%   scan up to the number of stations
%   nextindex will tell us where we got up to
    [A, count, errmsg, nextindex] = sscanf(s,'%d/%d/%d,%d:%d:%f,%f,%f,%f,%d');
%   scan the station ids and energy at the end of the string
    B = sscanf(s(nextindex+1:end),'%d,%d,');
    power(1:length(B),index)=B;
    if size(A,1)==10;
        data(index,:)=A;
    else
        error(err_index,:)=index;
        err_index=err_index+1;
    end
    index=index+1;
    s=fgets(fid);
    fend=feof(fid);
end

data=data(1:index-1,:);
power=power(:,1:index-1);

fclose all;

clear time start_index i j filename date days start_date s index fend
clear A B count errmsg fid nextindex