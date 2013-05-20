function [data,waveform] = s_import(filename)
%Imports an altered A file that includes power information for each station

fid=fopen(filename);
s=fgets(fid);
fend=feof(fid);
index=1;
data=zeros(1000,13);

A = sscanf(s,'%d %d %d %d %d %f %f %f %f %d %f %g');
rate=A(13);
waveform=zeros(1000,rate);

while(fend==0),
    if index>1;
        s=fgets(fid);
    end
    A = sscanf(s,'%d %d %d %d %d %f %f %f %f %d %f %g');
    s=fgets(fid);
    B = sscanf(s,repmat('%d ',1,rate));
    data(index,:)=A;
    waveform(index,:)=B;
    
    index=index+1;
    fend=feof(fid);

end

data=data(1:index-1,:);
waveform=waveform(1:index-1,:);

fclose all;

end