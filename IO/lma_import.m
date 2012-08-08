function [lma_data] = lma_import(date)
%%LMA_IMPORT(date) imports an LMA file from the CHUVA campaign. Date can be given as a
%%date vector [yyyy,mm,dd] or a datenum, or as a filename

%   11/30/11 - Michael Hutchins

lma_path='/Volumes/Data/LMA/';

if strmatch(class(date),'double')
    if length(date)==3
        filePre=sprintf('%s%04g-%02g-%02g/LYLOUT_%02g%02g%02g_',lma_path,date(1:3),date(1)-2000,date(2:3));
    elseif length(date)==1;
        date=datevec(date);
        date=date(1:3);
        filePre=sprintf('%s%04g-%02g-%02g/LYLOUT_%02g%02g%02g_',lma_path,date(1:3),date(1)-2000,date(2:3));
    else
        warning('Unknown Input Format');
    end
else
    error('Unrecognized filename.')
end

%Import every 2 minute file, strip off header data and load into data file

for i=1:720
    filename=sprintf('%s%04g00_0120.dat',filePre,2*(i-1));
    if file_check(filename)
        fid=fopen(filename);

        for j=1:55
            [A] = sscanf(fgets(fid),'%s');
        end

        data=fscanf(fid,'%g %g %g %g %g %g %s',[10,Inf]);
        data=data';

        if i==1
            lma_data=data;
        else
            lma_data=[lma_data;data];
        end
    end
    fclose all;
end

lma_data=[datevec(lma_data(:,1)/(24*60*60)+datenum(date)),lma_data(:,2:6)];

end