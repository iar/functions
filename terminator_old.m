function [path_day,path_night]=terminator_old(lat,long,time,stat_lat,stat_long)
%TERMINATOR(lat,long,time,stat_lat,stat_long)
%   Intersection of path with the day-night terminator
%   For a path starting at (lat,long), ending on (stat_lat,stat_long) this
%   will give what percent of the path is under a day-time ionosphere
%   (path_day) and what percent of the path is under a night-time
%   ionosphere (path_night) at a given time
%   (time = [year,month,day,hour,minute,second]).
%
%Michael Hutchins
%Updated 6/14/11
%       2/29/12 - Added cell structure
%                 Fixed some artifacts
% Requires files:
% intersections.m
% Mapping Toolbox (working on removing this dependency)


%% Check Inputs

    if lat<-90 || lat>90
        warning('Latitude out of range: fixed at boundary')
        if lat<-90
             lat = -89.9;
        elseif lat>90
             lat = 89.9;
        end
    end
    if long<-180 || long>180
        warning('Longitude out of range: wrapped')
        long = wrapTo180(long);
    end


%% Plotting for diagnostic purposes

    Plot=false; 

    if Plot
        stations
        lat=(29-1)*5-90;
        long=(37-1)*5-180;
        time=[2010,01,01,16,00,00];
        stat_lat=station_loc(1,1);
        stat_long=station_loc(1,2);
    end

%% Set up variables

    stroke=[lat,long];
    stat=[stat_lat,stat_long];
    day=time(1:3);
    time=time(4:6);

    t=time(1)+time(2)/60+time(3)/3600;
    day0=[day(1),01,01];

    d=datenum(day)-datenum(day0)+1;

%% Get terminator location

    M=-3.6+0.9856*d;
    nu=M+1.9*sind(M);
    lambda=nu+102.9;
    delta=22.8*sind(lambda)+0.6*sind(lambda)^3;
    b=-delta;
    l=-wrapTo180(15*(t-12));
    % D=datenum([2000,1,1,12,0,0])-datenum([day,time]);
    % GST=280.461+360.98564737*D;
    % GST=rem(GST,360);
    % LST=wrapTo180(GST-lat);


    % l=-15*t;
    % 
    % l=-wrapTo180(l);
    % b=-wrapTo180(b);
    % % l=-60
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

%% Get stroke path

    [p_lat,p_long]=track2(stroke(1),stroke(2),stat(1),stat(2));


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
    for i=1:99
        if -p_long(i+1)+p_long(i) < -300
            if i==4
                p_long=[p_long(1:i-2);-180;NaN;180;p_long(i+1:end)];
                p_lat=[p_lat(1:i-2);p_lat(i+1);NaN;p_lat(i);p_lat(i+1:end)];
            else
                p_long=[p_long(1:i-1);-180;NaN;180;p_long(i+1:end)];
                p_lat=[p_lat(1:i-1);p_lat(i+1);NaN;p_lat(i+1);p_lat(i+1:end)];
            end
            break;
        elseif -p_long(i+1)+p_long(i) >300
            if i==4
                p_long=[p_long(1:i-2);180;NaN;-180;p_long(i+1:end)];
                p_lat=[p_lat(1:i-2);p_lat(i+1);NaN;p_lat(i);p_lat(i+1:end)];
            else
                p_long=[p_long(1:i-1);180;NaN;-180;p_long(i+1:end)];
                p_lat=[p_lat(1:i-1);p_lat(i+1);NaN;p_lat(i+1);p_lat(i+1:end)];
            end
            break;
        end
    end
    if abs(t_long(1))==180 && isnan(t_long(2))
        t_lat=[t_lat(2:end-1);t_lat(1)];
        t_long=[t_long(2:end-1);t_long(1)];
    end
    if abs(p_long(1))==180 && isnan(p_long(2))
        if abs(p_long(1)-p_long(3))>300
            p_lat=[p_lat(2:end-1)];
            p_long=[p_long(2:end-1)];
        else
        p_lat=[p_lat(2:end-1);p_lat(1)];
        p_long=[p_long(2:end-1);p_long(1)];
        end
    end

%% Intersection with terminator

    [X,Y,I,J]=intersections(p_long,p_lat,t_long,t_lat);

%% Find sun location

    sun_term=t_lat(t_long<=(l+1) & t_long>=(l-1));

    Rsun=2;
    while isempty(sun_term)
        sun_term=t_lat(t_long<=(l+Rsun) & t_long>=(l-Rsun));
        Rsun=Rsun+1;
    end

    stroke5=false;

    R=.1;


    stroke_term=t_lat(t_long<=(stroke(2)+R) & t_long>=(stroke(2)-R));
    % stroke_term_long=t_long(t_long<=(stroke(2)+R) & t_long>=(stroke(2)-R));

    while isempty(stroke_term)
        stroke_term=t_lat(t_long<=(stroke(2)+R) & t_long>=(stroke(2)-R));
        R=R+0.1;
    end

    % while length(stroke_term)>1
    %     stroke_term=t_lat(t_long<=(stroke(2)+R) & t_long>=(stroke(2)-R));
    %     R=R-0.01;
    % end

    R=.1;

    % if length(stroke_term)>1
    %     stroke_term=stroke_term(1);
    % end

    iterate=true;
    iteration=1;
    iterate_down=false;
    
    
    
    while iterate==true


        if abs(stroke_term-stroke(1))<1 %| length(stroke_term)>1

    %         if isnan(p_long(5))
    %            stroke5_term=t_lat(t_long<=(p_long(7)+R) & t_long>=(p_long(7)-R));

    %         else
               stroke5_term=t_lat(t_long<=(p_long(5)+R) & t_long>=(p_long(5)-R));
    %         end

            if isempty(stroke5_term) && iterate_down==true;
                R=R+0.1;
                stroke5_term=mean(t_lat(t_long<=(p_long(5)+R) & t_long>=(p_long(5)-R)));
            end        
            if length(stroke5_term)>1
    %             stroke5_term=stroke5_term(1);
                  iterate_down=true;
            elseif isempty(stroke5_term)
                iterate_down=false;
            end

            if b>=sun_term %Sun Above Terminator
                if p_lat(5)>=stroke5_term %Stroke Above
                    day_start=true;
                    stroke5=true;
                    iterate=false;
                elseif p_lat(5)<=stroke5_term %Stroke Below
                    day_start=false;
                    iterate=false;
                    stroke5=true;
                end
            elseif b<=sun_term  %Sun below terminator
                if p_lat(5)<=stroke5_term %Stroke below
                    day_start=true;
                    iterate=false;
                    stroke5=true;
                elseif p_lat(5)>=stroke5_term %Stroke Above
                    day_start=false;
                    iterate=false;
                    stroke5=true;
                end
            else
               error('Daytime mismatch') 
            end  
        else
            stroke_term=t_lat(t_long<=(stroke(2)+R) & t_long>=(stroke(2)-R));
            if length(stroke_term)>1
    %             stroke_term=stroke_term(1);
                iterate_down=true;
            end

            if b>=sun_term %Sun Above Terminator
                if stroke(1)>=stroke_term %Stroke Above
                    day_start=true;
                    iterate=false;
                elseif stroke(1)<=stroke_term %Stroke Below
                    day_start=false;
                    iterate=false;
                end
            elseif b<=sun_term %Sun below terminator
                if stroke(1)<=stroke_term %Stroke below
                    day_start=true;
                    iterate=false;

                elseif stroke(1)>=stroke_term %Stroke Above
                    day_start=false;
                    iterate=false;
                end
            else
               error('Daytime mismatch') 
            end  
        end
        if iterate_down==true;
            R=R-0.1;
        else
            R=R+1;
        end
        iteration=iteration+1;

        if iteration>200
            disp('Error: Range runaway');
            disp(sprintf('Stroke: %g %g, Stat: %g %g',stroke,stat))
            disp(sprintf('Day: %g %g %g, Time: %g %g %g',day,time))
            day_start=true;
            iterate=false;
        end
    end

%% Percent of path in day/night

    %I is the percent path length from the stroke to the terminator

    if isempty(X);   
        I=100;
    end


    if day_start==true;
        path_day=I/100;
        path_night=1-I/100;
        if stroke5==true & I<50;
            path_night=I/100;
            path_day=1-I/100;
        end
    else
        path_day=1-I/100;
        path_night=I/100;
        if stroke5==true & I<50;
            path_day=I/100;
            path_night=1-I/100;
        end
    end


    if length(path_day)>1 && sum(X>-177 & X<177)==1
        path_day=path_day(X>-177 & X<177);
        path_night=path_night(X>-177 & X<177);
    elseif length(path_day)>1 && std(path_day)<.02
        path_day=mean(path_day);
        path_night=mean(path_night);
    elseif length(path_day)==3 && std(path_day)<0.05;
        path_day=path_day(2);
        path_night=path_night(2);
    end

%% Errors messages

    %These tend to be strokes from either wonky paths or due to the path of the
    %sferic following the terminator fairly closely and crossing several times
    if length(path_day)>1
        disp('Too many outputs')
        disp(sprintf('Stroke: %g %g, Stat: %g %g',stroke,stat))
        disp(sprintf('Day: %g %g %g, Time: %g %g %g',day,time))
        path_day=path_day(path_day<1);
        path_night=path_night(path_night<1);
        path_day=mean(path_day);
        path_night=mean(path_night);
    end
    % end

%% Diagnostics Plotting

    if Plot;
        figure
        load coast
        hold on
        plot(long,lat,'k');
        plot(p_long,p_lat);
        plot(t_long,t_lat);
        scatter(X,Y,'filled')
        scatter(l,b,'filled')
        scatter(stroke(2),stroke(1),'filled','b')
        daspect([1 1 1])
        ylim([-90,90])
        xlim([-180,180])
        % plot(t_lat)
        hold off
    end

end