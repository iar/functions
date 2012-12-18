function [pathDay,pathNight]=terminator_new(lat1,long1,time,lat2,long2)
% A new terminator program based on getting just the solar elevation angle
% along the path instead of the intersection with the actual terminator
% Can take in multiple values for lat2/long2 for a given value of
% lat1/long1

% http://en.wikipedia.org/wiki/Position_of_the_Sun



%% Check Inputs

    if length(lat1) > 1 && length(lat2) == 1
        lat1Temp = lat1;
        long1Temp = long1;
        lat1 = lat2;
        long1 = long2;
        lat2 = lat1Temp;
        long2 = long1Temp;
    end

    if lat1<-90 || lat1>90
        warning('Latitude 1 out of range: fixed at boundary')
        if lat1<-90
             lat1 = -89.9;
        elseif lat1>90
             lat1 = 89.9;
        end
    end
    
    if long1<-180 || long1>180
        warning('Longitude 1 out of range: wrapped')
        long1 = wrapTo180(long1);
    end
    
    if sum(lat2<-90)>0 || sum(lat2>90)>0
        warning('Latitude 2 out of range: fixed at boundary')
        if sum(lat2<-90)>0
             lat2(lat2<-90) = -89.9;
        elseif sum(lat2>90)>0
             lat2(lat2>90) = 89.9;
        end
    end
    
    if sum(long2<-180)>0 || sum(long2>180)>0
        warning('Longitude 2 out of range: wrapped')
        long2 = wrapTo180(long2);
    end

%% Get great circle path coordinates

pathLat = zeros(length(lat2),100);
pathLong = pathLat;

for i = 1 : length(lat2);

    [plat,plong]=track2(lat1,long1,lat2(i),long2(i));

    pathLat(i,:) = plat';
    pathLong(i,:) = plong';

end

%% Get solar altitude

% Days since J2000.0

n = datenum(time) - datenum([2000,1,1,11,58,55.816]);

% Mean solar longitude

L = 280.460 + 0.9856474 .* n;
L = wrapTo360(L);

% Mean solar anomaly

g = 357.528 + 0.9856003 .* n;
g = wrapTo360(g);

% Ecliptic Longitude

lambda = L + 1.915.*sind(g) + 0.020 .* sind(2*g);

% Julian Century from J2000.0

T = n./100;

% Obliquity of ecliptic

epsilon = (23 + 26/60 + 21.406/3600) - (46.836769/3600).*T - (0.0001831/3600).*T.^2 +...
    (0.00200340/3600).*T.^3 - (0.576/3600).*10^-6.*T.^4 - (4.34/3600).*10^-8.*T.^5;

% Solar Declination

delta = asind(sind(epsilon).*sind(lambda));

% Hour angle

localTime = time(4) + time(5)./60 + time(6)./3600;
localTime = localTime + pathLong./15;

h = localTime.*15 - 12*15;

% Solar altitude angle

altitude = asind(cosd(h).*cosd(delta).*cosd(pathLat) + sind(delta).*sind(pathLat));

%% Percent path in daylight/night

pathDay = sum(altitude > 0,2)./100;
pathNight = 1 - pathDay;


