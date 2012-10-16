function [data] = a_import(date)
%%A_IMPORT(date) imports an A file from date. Date can be given as a
%%date vector [yyyy,mm,dd], a datenum, or as a filename

dataPath = textread('dataPath.dat','%s\n');
index = 1;

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

a_path = sprintf('%sAfiles/',path);
a_path_alt = sprintf('%sAfiles/',pathAlt);

gz=false;

if strmatch(class(date),'double')
    
    if length(date)==1;
        date=datevec(date);
        date=date(1:3);
    elseif length(date)~=3
        warning('Unknown Input Format');
    end
    
    fileImport=sprintf('%sA%04g%02g%02g.loc',a_path,date(1:3));
    fileGzip=sprintf('%sA%04g%02g%02g.loc.gz',a_path,date(1:3));
 
    fileImportAlt=sprintf('%sA%04g%02g%02g.loc',a_path_alt,date(1:3));
    fileGzipAlt=sprintf('%sA%04g%02g%02g.loc.gz',a_path_alt,date(1:3));
    
    if exist(fileImport,'file');
       gFile = fileImport;
       fid = fopen(fileImport);
       gz = true;
        
    elseif exist(fileImportAlt,'file')
       gFile = fileImportAlt;
       fid = fopen(fileImportAlt);
       gz = true;
       
    elseif exist(fileGzip,'file');
       gFile = fileGzip;
       system(sprintf('gunzip %s',gFile));
       gFile = gFile(1:end-3);
       fid=fopen(fileGzip(1:end-3));
       gz = true;
       
    elseif exist(fileGzipAlt,'file');
       gFile = fileGzipAlt;
       system(sprintf('gunzip %s',gFile));
       gFile = gFile(1:end-3);
       fid=fopen(fileGzipAlt(1:end-3));
       gz = true;
    else
        error('File Not Found!')

    end
    

elseif strmatch(class(date),'char')
    fid=fopen(date);
else
    error('Unrecognized filename.')
end

data=fscanf(fid,'%d/%d/%d,%d:%d:%f,%f,%f,%f,%d',[10,Inf]);

data=data';

if gz

system(sprintf('gzip %s',gFile));

end

fclose all;

end