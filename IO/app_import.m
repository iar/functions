function [data] = app_import(date)
%Imports an altered A file that includes power information for each station

app_path='/Volumes/Time Machine/Data/APP_files/';

if strmatch(class(date),'double')
    if length(date)==1;
        date=datevec(date);
        date=date(1:3);
    elseif length(date)~=3
        warning('Unknown Input Format');
    end
    
    fileload=sprintf('%sAPP%04g%02g%02g.mat',app_path,date(1:3));
    
    if exist(fileload,'file');
       load(fileload)
       import=false;
    else
       fid=fopen(sprintf('%sAPP%04g%02g%02g.loc',app_path,date(1:3)));
       import=true;
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

    fclose all;

end

end