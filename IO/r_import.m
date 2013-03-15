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

r_path = sprintf('%sRfiles/',path);
r_path_alt = sprintf('%sRfiles/',pathAlt);

if strmatch(class(date),'double')
    
    RData=[0 0 0];

    if datenum(date) <= datenum([2005,7,26])
        for i = 0 : 23
            Date=[date(1:3),i];
            fid=fopen(sprintf('%sr%04g/r%04g%02g/R%04g%02g%02g%02g',r_path,Date(1),Date(1:2),Date(1:4)));
            if fid > -1
                rdata=fscanf(fid,'%g %f',[2,Inf]);
                rdata=rdata';
                fclose all;
                rdata=[rdata,zeros(size(rdata,1),1)];

                if size(RData,1)==1
                    RData=rdata;
                else
                    RData=[RData;rdata];
                end
            else
                fprintf('R%04g%02g%02g%02g Missing\n',Date(1:4));
            end
        end            
    else
        for i=0:10:1440
            Date=datevec(datenum([date(1:3),0,i,0]));
            fid=fopen(sprintf('%sr%04g/r%04g%02g/R%04g%02g%02g%02g%02g',r_path,Date(1),Date(1:2),Date(1:5)));
            if fid > -1

                rdata=fscanf(fid,'%g %f %g',[3,Inf]);
                rdata=rdata';
                fclose all;
                if size(RData,1)==1
                    RData=rdata;
                else
                    RData=[RData;rdata];
                end
            else
                fprintf('R%04g%02g%02g%02g%02g Missing\n',Date(1:5));
            end
        end
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