function lon = wrap180(lon)
%
%   Written By:  Michael Hutchins

q = (lon < -180) | (180 < lon);

a=lon(q)+180;
positiveInput=(a>0);
a=mod(a,360);
a((a==0) & positiveInput)=360;

lon(q) = a - 180;
