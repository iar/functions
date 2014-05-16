function [lat,long] = terminator_track(date)
% Get the lat/long track of the terminator for a given date.
%
%   Written By:  Michael Hutchins

%% Format date, day, and time

    day=date(1:3);
    time=date(4:6);

    t=time(1)+time(2)/60+time(3)/3600;
    day0=[day(1),01,01];

    d=datenum(day)-datenum(day0)+1;

%% Get position
	
	M=-3.6+0.9856*d;
    nu=M+1.9*sind(M);
    lambda=nu+102.9;
    delta=22.8*sind(lambda)+0.6*sind(lambda)^3;
    b=-delta;
    l=-wrapTo180(15*(t-12));

    psi=0:360;
    B=asind(cosd(b).*sind(psi));
    x=-cosd(l)*sind(b).*sind(psi)+sind(l).*cosd(psi);
    y=sind(l)*sind(b).*sind(psi)+cosd(l).*cosd(psi);
    x(x==0)=0.0001;
    L=atand(y./x);
    if sum(x<0)>0
        L(x<0)=L(x<0)+180;
    end
    t_long=wrapTo180(-L(:));
    t_lat=B(:);
	
%% Correct for crossing -180 - 180 boundary

    for i=1:360
        if (t_long(i)-t_long(i+1) < -300)
            t_long=[t_long(1:i-1);-180;NaN;180;t_long(i+1:end)];
            t_lat=[t_lat(1:i-1);t_lat(i+1);NaN;t_lat(i+1);t_lat(i+1:end)];
            break;
        elseif (t_long(i)-t_long(i+1)>300)
            t_long=[t_long(1:i-1);180;NaN;-180;t_long(i+1:end)];
            t_lat=[t_lat(1:i-1);t_lat(i+1);NaN;t_lat(i+1);t_lat(i+1:end)];
            break;
        end

    end

    if abs(t_long(1))==180 && isnan(t_long(2))
        t_lat=[t_lat(2:end-1);t_lat(1)];
        t_long=[t_long(2:end-1);t_long(1)];
	end

%% Output variables
	
	long = t_long;
    lat = t_lat;