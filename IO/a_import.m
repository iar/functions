function [data] = a_import(date)
%%A_IMPORT(date) imports an A file from date. Date can be given as a
%%date vector [yyyy,mm,dd], a datenum, or as a filename

a_path='/Volumes/Data/WWLLN/A_files/';
gz=false;

if strmatch(class(date),'double')
    if length(date)==3
        gfile=sprintf('%sA%04g%02g%02g.loc.gz',a_path,date(1:3));
        system(sprintf('gunzip %s',gfile));
        fid=fopen(sprintf('%sA%04g%02g%02g.loc',a_path,date(1:3)));
        gz=true;
    elseif length(date)==1;
        date=datevec(date);
        date=date(1:3);
        gfile=sprintf('%sA%04g%02g%02g.loc.gz',a_path,date(1:3));
        system(sprintf('gunzip %s',gfile));
        fid=fopen(sprintf('%sA%04g%02g%02g.loc',a_path,date(1:3)));
        gz=true;
    else
        warning('Unknown Input Format');
    end
elseif strmatch(class(date),'char')
    fid=fopen(date);
else
    error('Unrecognized filename.')
end

data=fscanf(fid,'%d/%d/%d,%d:%d:%f,%f,%f,%f,%d',[10,Inf]);

data=data';

if gz

gfile=sprintf('%sA%04g%02g%02g.loc',a_path,date(1:3));
system(sprintf('gzip %s',gfile));

end

fclose all;

end