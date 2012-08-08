function [location] = find_loc(vector,point)
%find_loc finds the index location of the value in vector closest to point
%   Michael Hutchins - 9/6/2011

diff=abs(vector-point);
location=find(diff==min(diff));

if length(location)==2
    diff=abs(vector-point*1.01);
    location=find(diff==min(diff));
end

if length(location)>1
    location=round(mean(location));
end

end

