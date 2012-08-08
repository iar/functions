tfile=tab_import('TfileThru20111013.txt');
index=size(tfile,1)+1;
stations
for i=tfile(end,1):datenum([2012,02,29]);
    [data,power]=ap_import(i);
    power=power';
    power(power==0)=NaN;
    power(isnan(power(:,1)),1)=0;
    power=power(:,1:2:end);
    power=power(:);
    power(isnan(power))=[];
    for j=1:size(station_loc,1)
        tfile(index,j+1)=sum(power==j-1);
    end
    tfile(index,1)=i;
    index=index+1;
end
date=datevec(tfile(end,1));
tfileName=sprintf('T%04g%02g%02g.dat',date(1:3));
tab_export(tfileName,tfile);
