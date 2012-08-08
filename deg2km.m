%Converts lat/long pairs into kilometers from equator/meridian
function [northKM,eastKM]=deg2km(lat,long)
lat=lat(:);
long=long(:);
R=6371;
northKM=(lat./360)*2*pi*R;
eastKM=(long./360)*2*pi*R.*cosd(lat);
end