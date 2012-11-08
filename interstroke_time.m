function [ interstroke ] = interstroke_time( data , resTime, resDist )
%INTERSTROKE_TIME calculates the time between successive nearby lightning strokes
    % The input resTime should be given in seconds and resDist in km
    % The defaults are 1 second and 25 km
    
    resTimeDefault = 1;
    resDistDefault = 25;
    
    switch nargin
        case 1
            resTime = resTimeDefault;
            resDist = resDistDefault;
        case 2
            resDist = resDistDefault;
    end
    
    % Split the data into 10000 long bins for faster searching    
    bin = 10000;
    binCount = floor(size(data,1)/bin);
        
    for k = 1 : binCount
            
        if k == binCount
            timeData = data(bin*(k-1)+1 : end,:);
        else
            timeData = data(bin*(k-1)+1 : bin*k,:);
        end
                    
        time = (datenum(timeData(:,1:6)) - min(datenum(timeData(:,1:6))));
        time = time*24*3600;

        
        interTime = zeros(size(timeData,1),1);
        interDist = interTime;

        for j = 1 : size(timeData,1);

            loc = time < time(j) &...
                  time >= time(j) - resTime;

            if sum(loc)>0

                prevTime = time(j) - time(loc);

                dist = vdist(timeData(loc,7),timeData(loc,8),timeData(j,7),timeData(j,8))./1000;

                loc = dist <= limitDist;

                if sum(loc)>0

                    locMin = abs(prevTime) == min(abs(prevTime));
                    if sum(locMin) == 1

                        interTime(j) = prevTime(locMin);
                        interDist(j) = dist(locMin);

                    end

                end

            end

        end
            
        if k == 1
            interstroke = [interTime,interDist];
        else
            
            interstroke = [interstroke ; [interTime,interDist]];
        end
        
        
    end
          
    


end

