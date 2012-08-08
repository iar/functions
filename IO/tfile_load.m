% This is wrong since it it looking at used packets while a tfile looks at
% total packets sent via rfiles. Woops. Only use TfilesThru5-11.txt

tfile=tfile_import('TfilesThru5-11.txt');
tic;
index=size(tfile,1)+1;
startDate=tfile(end,1)+1;
for i=startDate:datenum([2011,10,13]);
    [data,power]=ap_import(i);
    power=power';
    tfile(index,1)=i;
    for j=1:70
        if j==1
            tfile(index,j+1)=sum(power(:,1)==j-1);
        else
            tfile(index,j+1)=sum(sum(power(:,1:2:end)==j-1));
        end
    end
    index=index+1;
    date=datevec(i);
    fprintf('%04g/%02g/%02g Finished - %g seconds\n',date(1:3),toc);
end

exportName=sprintf('data/TfileThru%04g%02g%02g.txt',date(1:3));
tab_export(exportName,tfile);

figure
imagesc(tfile>500);

figure
plot(tfile(:,1),tfile(:,[19,48,64]+2));
datetick('x','mmm')