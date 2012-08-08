function [ Tfile ] = tfile_import(filename)
%tfile_import Import t-file to workspace

fid=fopen(filename);
s=fgets(fid);
fend=feof(fid);
index=1;
Tfile=zeros(3000,101);

while(fend==0)
    date=sscanf(s(1:11),'%g/%g/%g');
    station=sscanf(s(13:end),' %g');
    Tfile(index,:)=[datenum(date'),station'];
    fend=feof(fid);
    index=index+1;
    s=fgets(fid);    
end

Tfile=Tfile(1:index-1,:);

end

