function [flashes] = lis_import(date)
%Imports an altered A file that includes power information for each station


index=1;
dataPath = textread('dataPath.dat','%s\n');
path = '';
pathAlt = '';
for i = 1 : size(dataPath,1);
    if index == 1 && exist(dataPath{i},'dir')
        path = dataPath{i};
        index = index + 1;
    elseif index ==2 && exist(dataPath{i},'dir')
        pathAlt = dataPath{i};
    end
end


lis_path = sprintf('%sLIS/',path);
lis_path_alt = sprintf('%sLIS/',pathAlt);



if strmatch(class(date),'double')
    
    if length(date)==1;
        date=datevec(date);
        date=date(1:3);
    elseif length(date)~=3
        warning('Unknown Input Format');
    end
    
    
    fileLoad=sprintf('%slis%04g%02g%02g.mat',lis_path,date(1:3)); 
    fileLoadAlt=sprintf('%slis%04g%02g%02g.mat',lis_path_alt,date(1:3));
    
    if exist(fileLoad,'file');
       filename = fileLoad;
    elseif exist(fileLoadAlt,'file')
       filename = fileLoadAlt;
    else
        error('File Not Found!')
    end
    
elseif strmatch(class(date),'char')
    filename=date;
else
    error('Unrecognized filename.')
end

load(filename);

end
