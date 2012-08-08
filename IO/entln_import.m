function [data]=entln_import(date)

if strmatch(class(date),'double')
    if length(date)==3
        fid=fopen(sprintf('/Volumes/Data/ENTLN/ENTLN%04g%02g%02g.loc',date(1:3)));
    elseif length(date)==1;
        date=datevec(date);
        date=date(1:3);
        fid=fopen(sprintf('/Volumes/Data/ENTLN/ENTLN%04g%02g%02g.loc',date(1:3)));
    else
        warning('Unknown Input Format');
    end
elseif strmatch(class(date),'char')
    fid=fopen(date);
else
    error('Unrecognized filename.')
end

%2011-06-01T00:00:00.852282911,43.88088610,-83.70958050,1,-8030.00000000
[A] = sscanf(fgets(fid),'%s');
[B] = sscanf(fgets(fid),'%g-%g-%gT%g:%g:%f,%f,%f,%g,%f');
data=fscanf(fid,['%g-%g-%g' 'T' '%g:%g:%f,%f,%f,%g,%f'],[10,Inf]);

data=data';

data=[B';data];

fclose all;

end