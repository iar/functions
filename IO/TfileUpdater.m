% TfileUpdate updates T files to the latest data, or regenerates it from
% the R-files
%
%   Written By:  Michael Hutchins

stations
tic;
dateRange = datenum([2013,05,13]):datenum([2013,11,11]);
tfile = zeros(length(dateRange),size(station_loc,1)+1);

for i = 1 : length(dateRange);
    Date = datevec(dateRange(i));
    Date = Date(1:3);
    rdata = r_import(Date);
    
    rdata = rdata(:,1);
    
    n = hist(rdata,[0:size(station_loc,1)-1]);
    
    tfile(i,1) = dateRange(i);
    tfile(i,2:end) = n;
    
    fprintf('%s Done - %.2f seconds elapsed\n',datestr(dateRange(i)),toc);
    
end

tfileName=sprintf('/wd2/Tfiles/T%04g%02g%02g_partial.dat',Date(1:3));
tab_export(tfileName,tfile);
