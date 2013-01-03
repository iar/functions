function [data] = ae_import(date)
%Imports an altered A file that includes energy information for each station

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

ae_path = sprintf('%sAEfiles/',path);
ae_path_alt = sprintf('%sAEfiles/',pathAlt);

import = true;

if strmatch(class(date),'double')
    if length(date)==1;
        date=datevec(date);
        date=date(1:3);
    elseif length(date)~=3
        warning('Unknown Input Format');
    end
    
    fileload=sprintf('%sAE%04g%02g%02g.mat',ae_path,date(1:3));
    fileimport=sprintf('%sAE%04g%02g%02g.loc',ae_path,date(1:3));
 
    fileloadAlt=sprintf('%sAE%04g%02g%02g.mat',ae_path_alt,date(1:3));
    fileimportAlt=sprintf('%sAE%04g%02g%02g.loc',ae_path_alt,date(1:3));
    
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

    data=fscanf(fid,'%d/%d/%d,%d:%d:%f,%f,%f,%f,%d,%g,%g,%g',[13,Inf]);

    data=data';

    fclose(fid);

end


end
