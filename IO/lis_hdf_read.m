function [ flashes ] = lis_hdf_read( filename )
%LIS_HDF_READ imports LIS hdf files and extracts flash data

flash = hdfread(filename,'flash');

time = double(flash{1}');
duration = double(flash{2}');
viewtime = double(flash{3}');
location = double(flash{4}');
radiance = double(flash{5}');
area = double(flash{6}');
groups = double(flash{10}');
events = double(flash{11}');
confidence = double(flash{14}');

% UTC is behind TAI by 34 seconds in 2011, 35 seconds after 2012/6/30

TAI_UTC = 34;

time = (time + TAI_UTC) ./ 86400;

date=datevec(time + datenum([1993,1,1]));

flashes = ([date,location,events,confidence,radiance,area,duration]);

end

