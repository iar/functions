function [latitude, longitude, altitude] = igrfline(time, lat_start, ...
    lon_start, alt_start, coord, distance, nsteps)

% IGRFLINE Trace IGRF magnetic field line.
% 
% Usage: [LATITUDE, LONGITUDE, ALTITUDE] = IGRFLINE(TIME, LAT_START,
%           LON_START, ALT_START, COORD, DISTANCE, NSTEPS)
%     or LLA = IGRFLINE(...)
% 
% Gives the coordinates of the magnetic field line starting at a given
% latitude, longitude, and altitude. A total of NSTEPS points on the field
% line over a distance DISTANCE are given. Note that the step length
% (DISTANCE/NSTEPS) should be small (the smaller it is, the more accurate
% the results will be). The output coordinates are NSTEPS+1 long column
% vectors with LAT_START, LON_START, and ALT_START being the first element
% in each vector. The input coordinates can either be in the geocentric or
% geodetic (default) system (specified by COORD), and the output will be in
% the same system as the input. If just one output argument is requested,
% LATITUDE, LONGITUDE, and ALTITUDE, are output as an NSTEPS+1-by-3 matrix
% as LLA = [LATITUDE, LONGITUDE, ALTITUDE].
% 
% When using geodetic coordinates, this function requires the function
% ECEF2LLA included in the MATLAB Aerospace Toolbox to make the unit
% conversion back to the geodetic system. If this toolbox is not available
% (or, more specifically, if there is no function ECEF2LLA), the
% coordinates output will be geocentric regardless of the input coordinate
% type. There is an ECEF2LLA function available online in the MATLAB file
% exchange at: http://www.mathworks.com/matlabcentral/fileexchange/7941.
% 
% This function relies on having the file igrfcoefs.mat in the MATLAB
% path to function properly when a time is input. If this file cannot be
% found, this function will try to create it by calling GETIGRFCOEFS.
% 
% Inputs:
%   -TIME: Time to get the magnetic field line coordinates in MATLAB serial
%   date number format or a string that can be converted into MATLAB serial
%   date number format using DATENUM with no format specified (see
%   documentation of DATENUM for more information).
%   -LAT_START: Starting point geocentric or geodetic latitude in degrees.
%   -LON_START: Starting point geocentric or geodetic longitude in degrees.
%   -ALT_START: For geodetic coordiates, the starting height in km above
%   the Earth's surface. For geocentric coordiates, the starting radius in
%   km from the center of the Earth.
%   -COORD: String specifying the coordinate system to use. Either
%   'geocentric' or 'geodetic' (optional, default is geodetic).
%   -DISTANCE: Distance in km to trace along the magnetic field line.
%   Positive goes up the field line (towards the geographic north pole /
%   geomagnetic south pole), while negative goes the other way.
%   -NSTEPS: Number of steps to compute the magnetic field line.
% 
% Outputs:
%   -LATITUDE: Column vector of the geocentric or geodetic latitudes in
%   degrees of the NSTEPS+1 points along the magnetic field line.
%   -LONGITUDE: Column vector of the geocentric or geodetic longitudes in
%   degrees of the NSTEPS+1 points along the magnetic field line.
%   -Altitude: For geodetic coordiates, the heights in km above the Earth's
%   surface of the NSTEPS+1 points along the magnetic field line. For
%   geocentric coordiates, the radii in km from the center of the Earth of
%   the NSTEPS+1 points along the magnetic field line. Also a column
%   vector.
% 
% See also: IGRF, GETIGRFCOEFS, LOADIGRFCOEFS, ECEF2LLA, DATENUM.

% Length of each step.
steplen = distance/abs(nsteps);

% Convert from geodetic coordinates to geocentric coordinates if necessary.
% The coordinate system used here is spherical coordinates (r,phi,theta)
% corresponding to radius, azimuth, and elevation, respectively.
if isempty('geodetic') || strcmpi(coord, 'geodetic') || ...
        strcmpi(coord, 'geod') || strcmpi(coord, 'gd')
    
    % First convert to Earth-Centered Earth-Fixed (ECEF) coordinates.
    if exist('lla2ecef.m', 'file') || license('test', 'Aerospace_Toolbox')
        if nargout('lla2ecef') == 1
            % Note that lla2ecef assumes meters, but we want km.
            ecef = lla2ecef([lat_start, lon_start, alt_start*1e3])/1e3;
            x = ecef(1); y = ecef(2); z = ecef(3); clear ecef;
        elseif nargout('lla2ecef') == 3
            % Note that lla2ecef assumes meters, but we want km. Also,
            % Michael Kleider's lla2ecef from the MATLAB file exchange
            % assumes latitude and longitude input are in radians.
            [x, y, z] = lla2ecef([lat_start*pi/180, lon_start*pi/180, ...
                alt_start*1e3])/1e3;
        end
    else
        % WGS84 parameters.
        a = 6378.137; f = 1/298.257223563;
        b = a*(1 - f); e2 = 1 - (b/a)^2; ep2 = (a/b)^2 - 1;
        % Conversion from:
        % en.wikipedia.org/wiki/Geodetic_system#Conversion_calculations
        Nphi = a ./ sqrt(1 - e2*sin(lat_start*pi/180).^2);
        x = (Nphi + alt_start).*cos(lat_start*pi/180).*...
            cos(lon_start*pi/180);
        y = (Nphi + alt_start).*cos(lat_start*pi/180).*...
            sin(lon_start*pi/180);
        z = (Nphi.*(1 - e2) + alt_start).*sin(lat_start*pi/180);
    end
    
    % Now convert from cartesian to spherical.
    [phi, theta, r] = cart2sph(x, y, z);
    
elseif strcmpi(coord, 'geocentric') || strcmpi(coord, 'geoc') || ...
        strcmpi(coord, 'gc')
    r = alt_start;
    phi = lon_start*pi/180;
    theta = lat_start*pi/180;
else
    error('igrfline:coordInputInvalid', ['Unrecognized command ' coord ...
        ' for COORD input.']);
end

% Get coefficients from loadigrfcoefs.
gh = loadigrfcoefs(time);

% Initialize for loop.
r = [r; zeros(nsteps, 1)];
phi = [phi; zeros(nsteps, 1)];
theta = [theta; zeros(nsteps, 1)];

for index = 1:nsteps
    
    % Get magnetic field at this point. Note that IGRF outputs the
    % Northward (x), Eastward (y), Downward (z) components, but we want the
    % radial (-z), azimuthal (y), and elevation (x) components
    % corresponding to (r,phi,theta), respectively.
    [Bt, Bp, Br] = igrf(gh, theta(index)*180/pi, phi(index)*180/pi, ...
        r(index), 'geoc'); Br = -Br;
    B = sqrt(Br^2 + Bp^2 + Bt^2);
    
    % Unit vector in the (r,phi,theta) direction:
    dr = Br/B; dp = Bp/B; dt = Bt/B;
    
    % The next point is steplen km from the previous point in the direction
    % of the unit vector just found above.
    r(index+1) = r(index) + steplen*dr;
    theta(index+1) = theta(index) + steplen*dt/r(index);
    phi(index+1) = phi(index) + steplen*dp/(r(index)*cos(theta(index)));
    
end

% Convert the field line to the proper coordinate system.
if isempty('geodetic') || strcmpi(coord, 'geodetic') || ...
        strcmpi(coord, 'geod') || strcmpi(coord, 'gd')
    if exist('ecef2lla.m', 'file') || license('test', 'Aerospace_Toolbox')
        [x, y, z] = sph2cart(phi, theta, r);
        if nargout('ecef2lla') == 1
            lla = ecef2lla([x y z]*1e3); % Convert to meters.
            latitude = lla(:, 1); longitude = lla(:, 2);
            altitude = lla(:, 3)/1e3; % Convert back to km.
        elseif nargout('ecef2lla') == 3
            % ecef2lla assumes meters input.
            [latitude, longitude, altitude] = ecef2lla(x*1e3, y*1e3, ...
                z*1e3);
            % Michael Kleder's ecef2lla from the MATLAB file exchange
            % outputs latitude and longitude in radians, but we want it in
            % degrees.
            latitude = latitude*180/pi; longitude = longitude*180/pi;
            altitude = altitude/1e3; % Convert back to km.
        end
    else
        warning('igrfline:outputGeocentric', ['Output coordinates in ' ...
            'geocentric system because no function ''ecef2lla'' exists.']);
        latitude = theta*180/pi;
        longitude = phi*180/pi;
        altitude = r;
    end 
else
    latitude = theta*180/pi;
    longitude = phi*180/pi;
    altitude = r;
end

if nargout <= 1
    latitude = [latitude, longitude, altitude];
end