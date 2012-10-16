function [RData] = r_import(date)
%Imports an altered A file that includes power information for each station


dataPath = textread('dataPath.dat','%s\n');
index = 1;
for i = 1 : size(dataPath,1);
    if index == 1 && exist(dataPath{i},'dir')
        path = dataPath{i};
        index = index + 1;
    elseif index == 2 && exist(dataPath{i},'dir')
        pathAlt = dataPath{i};
    end
end
% path = dataPath{1};
% pathAlt = dataPath{2};

r_path = sprintf('%sRfiles/',path);
r_path_alt = sprintf('%sRfiles/',pathAlt);


if strmatch(class(date),'double')

    if length(date)==3
        Range='day';
    elseif length(date)==4
        Range='hour';
    elseif length(date)>=5
        Range='minute';
    end

    RData=[0 0 0];

    if strcmp(Range,'day');
        for i=0:10:1440
            Date=datevec(datenum([date(1:3),0,i,0]));
            fid=fopen(sprintf('%sr%04g/r%04g%02g/R%04g%02g%02g%02g%02g',r_path,Date(1),Date(1:2),Date(1:5)));
            rdata=fscanf(fid,'%g %f %g',[3,Inf]);
            rdata=rdata';
            fclose all;
            if size(RData,1)==1
                RData=rdata;
            else
                RData=[RData;rdata];
            end
        end
    elseif strcmp(Range,'hour');
        for i=0:10:50
            Date=datevec(datenum([date(1:4),i,0]));
            fid=fopen(sprintf('%sr%04g/r%04g%02g/R%04g%02g%02g%02g%02g',r_path,Date(1),Date(1:2),Date(1:5)));
            rdata=fscanf(fid,'%g %f %g',[3,Inf]);
            rdata=rdata';
            fclose all;
            if size(RData,1)==1
                RData=rdata;
            else
                RData=[RData;rdata];
            end
        end
    elseif strcmp(Range,'minute')
        Date=datevec(datenum([date(1:4),floor(date(5)/10)*10,0]));
        fid=fopen(sprintf('%sr%04g/r%04g%02g/R%04g%02g%02g%02g%02g',r_path,Date(1),Date(1:2),Date(1:5)));
        rdata=fscanf(fid,'%g %f %g',[3,Inf]);
        rdata=rdata';
        fclose all;
        RData=rdata;

    end
elseif strmatch(class(date),'char')
    fid=fopen(date);
    rdata=fscanf(fid,'%g %f %g',[3,Inf]);
    RData=rdata';
    fclose all;   
else
    error('Unrecognized filename.')
end

end