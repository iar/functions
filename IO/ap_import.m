function [data,power] = ap_import(date)
%Imports an altered A file that includes power information for each station

import=true;

dataPath = textread('dataPath.dat','%s\n');
path = dataPath{1};
pathAlt = dataPath{2};

ap_path = sprintf('%sAPfiles/',path);
ap_path_alt = sprintf('%sAPfiles/',pathAlt);


if strmatch(class(date),'double')
    if length(date)==1;
        date=datevec(date);
        date=date(1:3);
    elseif length(date)~=3
        warning('Unknown Input Format');
    end
    
    fileload=sprintf('%sAP%04g%02g%02g.mat',ap_path,date(1:3));
    fileimport=sprintf('%sAP%04g%02g%02g.loc',ap_path,date(1:3));
 
    fileloadAlt=sprintf('%sAP%04g%02g%02g.mat',ap_path_alt,date(1:3));
    fileimportAlt=sprintf('%sAP%04g%02g%02g.loc',ap_path_alt,date(1:3));
    
    if exist(fileload,'file');
       load(fileload)
       import=false;
    elseif exist(fileloadAlt,'file')
        load(fileloadAlt);
        import=false;
    elseif exist(fileimport,'file');
       fid=fopen(fileimport);
       import=true;
    elseif exist(fileimportAlt,'file');
        fid=fopen(fileloadAlt);
        import=true;
    else
        error('File Not Found!')
    end
    
    
elseif strmatch(class(date),'char')
    fid=fopen(date);
    import=true;
else
    error('Unrecognized filename.')
end

if import

s=fgets(fid);
fend=feof(fid);
index=1;
power=zeros(70,1000000);
data=zeros(1000000,10);
% err_index=1;

while(fend==0),
    if index>1;
        s=fgets(fid);
    end
    [A, count, errmsg, nextindex] = sscanf(s,'%d/%d/%d,%d:%d:%f,%f,%f,%f,%d');
    B = sscanf(s(nextindex+1:end),'%d,%d,');
    power(1:length(B),index)=B;
    if size(A,1)==10;
        data(index,:)=A;
    else
%         error(err_index,:)=index;
        err_index=err_index+1;
    end
    index=index+1;
    fend=feof(fid);

end

data=data(1:index-1,:);
power=power(:,1:index-1);

fclose all;

clear time start_index i j filename date days start_date s index fend
clear A B count errmsg fid nextindex

end

end