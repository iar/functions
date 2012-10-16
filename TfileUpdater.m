tfile=tab_import('T20120215.dat');
index=size(tfile,1)+1;
stations
tic
for i=tfile(end,1):datenum(floor(now)-1);
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
    fprintf('%s Done - %g seconds elapsed\n',datestr(i),toc);
end
date=datevec(tfile(end,1));
tfileName=sprintf('T%04g%02g%02g.dat',date(1:3));
tab_export(tfileName,tfile);

%% Print names/dates

if true
    on = tfile(:,2:end) > 5000;
    for i = 1 : size(station_loc,1)
        onDays = find(on(:,i));
        fprintf('%s - %s\n',station_name{i},datestr(tfile(onDays(1),1)));
    end
end