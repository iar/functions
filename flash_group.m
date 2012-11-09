function [ flash ] = flash_group( data )
%FLASH_GROUP groups stroke level data into flash level data
    % Flash is defined as strokes within 1 second and 25 km of each other
    % flash structure is:
    % [date][time of first stroke][centroid][area][duration][max
    % energy][median energy][multiplicty]
    % Area is found as the the circle defined by the mean distance from
    % stroke to centroid


    resDist = 25;
    resTime = 1;

    flashData = zeros(size(data,1),13);
    flashIndex = 1;

    % Sort data by time
    data = [data,datenum(data(:,1:6))];
    data = sortrows(data,size(data,2));
    data(:,end) = (data(:,end) - data(1,end))*24*3600;


    % Split the data into 2500 long bins for faster searching    
    bin = 2500;
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
        time = timeData(:,end);

        % Process each stroke
        for j = 1 : size(timeData,1);

            if timeData(j,end)>=0

                % Set default in case no other strokes are found
                flashData(flashIndex,:) = [timeData(j,1:8),0,0,timeData(j,11),0,0];

                % Select strokes from resTime before to stroke time and within
                % sensible distances (km/50 ~ 2*degree box)
                loc = time > time(j) &...
                      time <= time(j) + resTime &...
                      timeData(:,7) >= timeData(j,7) - resDist/50 &...
                      timeData(:,7) <= timeData(j,7) + resDist/50 &...
                      timeData(:,8) >= timeData(j,8) - resDist/50 &...
                      timeData(:,8) <= timeData(j,8) + resDist/50;

                % Check to see if there is a matching stroke 
                if sum(loc)>0

                    % Get distnce between the strokes
                    dist = vdist(timeData(loc,7),timeData(loc,8),timeData(j,7),timeData(j,8))./1000;

                    % Find strokes within resDist km
                    locDist = dist <= resDist;

                    % Check to see if there is a stroke
                    if sum(locDist)>0

                        flashLoc = find(loc);
                        flashLoc = flashLoc(locDist);

                        flashStrokes = [timeData(j,:);timeData(flashLoc,:)];

                        centroid = mean(flashStrokes(:,7:8),1);
                        radius = mean(vdist(flashStrokes(:,7),flashStrokes(:,8),centroid(1),centroid(2))./1000);
                        area = pi * radius^2;
                        multiplicity = size(flashStrokes,1);
                        maxEnergy = max(flashStrokes(:,11));
                        medEnergy = median(flashStrokes(flashStrokes(:,11)>0,11));
                        duration = range(flashStrokes(:,end));

                        flashData(flashIndex,7:13)=[centroid,area,duration,...
                               maxEnergy,medEnergy,multiplicity];

                        flashIndex = flashIndex + 1;

                        timeData(flashLoc,end) = -1;
                    end

                end
            end
        end    
    end

    flashData = flashData(1:flashIndex-1,:);
    
end

