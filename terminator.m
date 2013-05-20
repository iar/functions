function [pathDay,pathNight]=terminator(lat1,long1,time,lat2,long2)
% A new terminator program based on getting just the solar elevation angle
% along the path instead of the intersection with the actual terminator
% Can take in multiple values for lat2/long2 for a given value of
% lat1/long1
%
%   Written By:  Michael Hutchins

% http://en.wikipedia.org/wiki/Position_of_the_Sun

%% Check Inputs

    lat1 = lat1(:);
    long1 = long1(:);
    lat2 = lat2(:);
    long2 = long2(:);
    
    % If any inputs are empty, output empty (instead of crashing)
    
    if isempty(time) || isempty(lat1) || isempty(long1) ||...
                       isempty(lat2) || isempty(long2)
        pathDay = [];
        pathNight = [];
        return
    end
    
    % Check long/lat pairs are of the same length
    
    if length(lat1) ~= length(long1)
        error('Lat1 and Long1 do not match')
    end
    
    if length(lat2) ~= length(long2)
        error('Lat2 and Long2 do not match')
    end
    
    % Format datenums to datevecs
        
    if time(1) > 3000
        time = time(:);
    end
    
    if size(time,2) == 1
        time = datevec(time);
    end
    
    % Cut out latitude near poles
    
    if sum(lat1(:) < -90) > 0
        lat1(lat1 < -90) = -89.9;
        warning('Latitude 1 out of range: fixed at boundary')
    end
    
    if sum(lat1(:) > 90) > 0
        lat1(lat1 > 90) = 89.9;
        warning('Latitude 1 out of range: fixed at boundary')
    end

    if sum(lat2(:) < -90) > 0
        lat2(lat2 < -90) = -89.9;
        warning('Latitude 2 out of range: fixed at boundary')
    end
    
    if sum(lat2(:) > 90) > 0
        lat2(lat2 > 90) = 89.9;
        warning('Latitude 2 out of range: fixed at boundary')
    end

    % Wrap longitude to 180

    if sum(long1(:) < -180) > 0 || sum(long1(:) > 180) > 0
        long1 = wrapTo180(long1);
        warning('Longitude 1 out of range: wrapped')
    end

    if sum(long2(:) < -180) > 0 || sum(long2(:) > 180) > 0
        long2 = wrapTo180(long2);
        warning('Longitude 2 out of range: wrapped')
    end
    
    % Reformat so lat1/long1 and lat2/long2 are the same length
    
    size1 = length(lat1);
    size2 = length(lat2);
    
    if size1 ~= size2
        if size1 > size2 && size2 == 1
            lat2 = repmat(lat2,size1,1);
            long2 = repmat(long2,size1,1); 
        elseif size2 > size1 && size1 == 1
            lat1 = repmat(lat1,size2,1);
            long1 = repmat(long1,size2,1); 
        else
            error('Lat/long inputs do not match')
        end
    end
    
    % Reformat so time and lat/long are the same length
    
    size1 = length(lat1);        
    sizeD = size(time,1);
    
    if size1 ~= sizeD
        if size1 > sizeD && sizeD == 1
            time = repmat(time,size1,1);
        elseif sizeD > size1 && size1 == 1
            lat1 = repmat(lat1,sizeD,1);
            long1 = repmat(long1,sizeD,1); 
            lat2 = repmat(lat2,sizeD,1);
            long2 = repmat(long2,sizeD,1);
        else
            error('Lat/long and time inputs do not match')
        end
    end
        
%% Get great circle path coordinates

[pathLat,pathLong] = track2(lat1,long1,lat2,long2);

pathLat = real(pathLat)';
pathLong = real(pathLong)';

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

localTime = time(:,4) + time(:,5)./60 + time(:,6)./3600;
localTime = bsxfun(@plus,localTime,pathLong./15);

h = localTime.*15 - 12*15;

% Solar altitude angle

altitude = asind(bsxfun(@times,cosd(h),cosd(delta)).*cosd(pathLat) + bsxfun(@times,sind(delta),sind(pathLat)));

%% Percent path in daylight/night

pathDay = sum(altitude > 0,2)./100;
pathNight = 1 - pathDay;


