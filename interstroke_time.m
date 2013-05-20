function [ interstroke ] = interstroke_time( data , resTime, resDist )
%INTERSTROKE_TIME calculates the time between successive nearby lightning strokes
    % The input resTime should be given in seconds and resDist in km
    % The defaults are 1 second and 25 km
    
    % In general: <1ms are the same process for a single stroke
    %             1ms - 1s are the same flash
    %             1s to 600s are the same storm (upper bound not strict)
%
%   Written By:  Michael Hutchins    
    
    resTimeDefault = 1;
    resDistDefault = 25;
    
    % Set defaults if not specified
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
        
    % Go through each bin
    for k = 1 : binCount
            
        % Select the data in bin k
        if k == binCount
            timeData = data(bin*(k-1)+1 : end,:);
        else
            timeData = data(bin*(k-1)+1 : bin*k,:);
        end
        
        % Convert datevec formatted time to seconds since start of bin
        time = (datenum(timeData(:,1:6)) - min(datenum(timeData(:,1:6))));
        time = time*24*3600;

        % Initialize arrays to store interstroke data
        interTime = zeros(size(timeData,1),1);
        interDist = interTime;
        interEnergy = interTime;
        % Process each stroke
        for j = 1 : size(timeData,1);

            % Select strokes from resTime before to stroke time and within
            % sensible distances (km/50 ~ 2*degree box)
            loc = time < time(j) &...
                  time >= time(j) - resTime &...
                  timeData(:,7) >= timeData(j,7) - resDist/50 &...
                  timeData(:,7) <= timeData(j,7) + resDist/50 &...
                  timeData(:,8) >= timeData(j,8) - resDist/50 &...
                  timeData(:,8) <= timeData(j,8) + resDist/50;

            % Check to see if there is a matching stroke 
            if sum(loc)>0

                % Get time from previous stroke to current stroke
                prevTime = time(j) - time(loc);
                prevEnergy = timeData(loc,11);
                
                % Get distnce between the strokes
                dist = vdist(timeData(loc,7),timeData(loc,8),timeData(j,7),timeData(j,8))./1000;

                % Find strokes within resDist km
                locDist = dist <= resDist;

                % Check to see if there is a stroke
                if sum(locDist)>0

                    % Find the closest stroke in time
                    locMin = abs(prevTime) == min(abs(prevTime(locDist)));
                    
                    
                    % Store that strokes time and distance
                    if sum(locMin) == 1

                        interTime(j) = prevTime(locMin);
                        interDist(j) = dist(locMin);
                        interEnergy(j) = prevEnergy(locMin);

                    end

                end

            end

        end
            
        % Store time and distance from each bin in interstroke
        if k == 1
            interstroke = [interTime,interDist,interEnergy];
        else
            
            interstroke = [interstroke ; [interTime,interDist,interEnergy]];
        end
        
        
    end
          
    


end

