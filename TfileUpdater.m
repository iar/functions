% TfileUpdate updates T files to the latest data, or regenerates it from
% the R-files

stations
tic;
dateRange = datenum([2005,01,01]):datenum([2013,01,30]);
tfile = zeros(length(dateRange),size(station_loc,1)+1);

for i = 1 : length(dateRange);
    Date = datevec(dateRange(i));
    Date = Date(1:3);
    rdata = r_import(Date);
    
    rdata = rdata(:,1);
    
    n = hist(rdata,[0:size(station_loc,1)]);
    
    tfile(i,1) = dateRange(i);
    tfile(i,2:end) = n;
    
    fprintf('%s Done - %.2f seconds elapsed\n',datestr(dateRange(i)),toc);
    
end

tfileName=sprintf('T%04g%02g%02g.dat',Date(1:3));
tab_export(tfileName,tfile);
