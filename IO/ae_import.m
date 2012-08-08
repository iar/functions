function [data] = ae_import(date)
%Imports an altered A file that includes energy information for each station

ae_path='/Volumes/Data/WWLLN/AE_files/';
app_path='/Volumes/Data/WWLLN/APP_files/';
app=false;

if strmatch(class(date),'double')
    if length(date)==1;
        date=datevec(date);
        date=date(1:3);
    elseif length(date)~=3
        warning('Unknown Input Format');
    end
    
    fileload=sprintf('%sAE%04g%02g%02g.mat',ae_path,date(1:3));
    fileloadAlt=sprintf('%sAPP%04g%02g%02g.mat',app_path,date(1:3));
    fileimport=sprintf('%sAE%04g%02g%02g.loc',ae_path,date(1:3));
    fileimportAlt=sprintf('%sAPP%04g%02g%02g.loc',app_path,date(1:3)); 
    
    if exist(fileload,'file');
       load(fileload)
       import=false;
    elseif exist(fileimport,'file');
       fid=fopen(fileimport);
       import=true;
    elseif exist(fileloadAlt,'file')
        load(fileloadAlt);
        app=true;
        import=false;
    else exist(fileimportAlt,'file');
        fid=fopen(fileloadAlt);
        app=true;
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

if app
    data(:,11:12)=data(:,11:12).*1.33;
end

end