function [dataGrouped,groupNum]=connected_component(data,rdist,zdist)
%connected_component groups data based on the radial distant (in degrees)
%   and the time difference (in hours). Currently set to work with WWLLN
%   formatted data

%   Created by: Michael Hutchins 

switch nargin
    case 1
        rdist=0.25;
        zdist=0.5;
end

%Future work:
%   Documents
%   "Backtracking", connecting two unrelated storms
% tic

%% Set minimums

% xdist=0.25; %In degrees
% ydist=0.25; %In degrees
% rdist=0.25;
% zdist=0.5; %In hours

% %% Import Data

% data_full=app_import([2010,06,16]);
% data_full=app_import('APP20100615.loc');

%% Shape Data

% data_full=data_full(data_full(:,4)<6,:);
data_full=[data,zeros(size(data,1),1)];

%% Chop and run data in 30 minute segments

segSize=30; %Segmentation size in minutes

if segSize<zdist*60
    warning('Segmentation size too small, groups will be missed. Increase segSize or decrease zdist.');
end
segTime=(datenum(data_full(:,1:6))-datenum(data_full(1,1:6)))*24*60;

Seg=ceil((segTime(end)-segTime(1))/segSize);

%% Find starting group number

groupNum=max(data_full(:,14))+1;
removedGroups=[];

%% Go through each segment

for m=1:Seg
    Time=segTime>=(segSize*(m-1)) &...
         segTime<(segSize*(m+1));
    data=data_full(Time,:);

    %% Rename Variables

    x=data(:,8);
    y=data(:,7);
    z=datenum(data(:,1:6))*24;



    %% Group Data

    for i=1:size(data,1);

    %   %Box Method - fast but inaccurate
    %     neighbors= x <= x(i) + xdist &...
    %                x >= x(i) - xdist &...
    %                y <= y(i) + ydist &...
    %                y >= y(i) - ydist &...
    %                z <= z(i) + zdist &...
    %                z >= z(i) - zdist;
        %Circle method
        if abs(x(i))>150; %To allow storms to wrap around
            X=wrapTo180(x+180);
            neighbors=sqrt((X-X(i)).^2+(y-y(i)).^2)<=rdist &...
                       z <= z(i) + zdist &...
                       z >= z(i) - zdist;        
        else
            neighbors=sqrt((x-x(i)).^2+(y-y(i)).^2)<=rdist &...
                       z <= z(i) + zdist &...
                       z >= z(i) - zdist;        
        end
        oldGroups=unique(data(neighbors,14));
        oldGroups=oldGroups(oldGroups>0);

        if data(i,14)==0
            if isempty(oldGroups)
                data(neighbors,14)=groupNum;
                groupNum=groupNum+1;
            elseif length(oldGroups)==1
                data(neighbors,14)=oldGroups;
            elseif length(oldGroups)>1;
                for j=1:length(oldGroups)
                    data(data(:,14)==oldGroups(j),14)=groupNum;
                    data_full(data_full(:,14)==oldGroups(j),14)=groupNum;
                end
                data(neighbors,14)=groupNum;
                groupNum=groupNum+1;
                removedGroups=[removedGroups;oldGroups(:)];
            end
        elseif data(i,14)>0
            if isempty(oldGroups)
                error('Something went wrong!');
            elseif length(oldGroups)==1
                if oldGroups~=data(i,14)
                    error('Somethign went wrong!');
                end
                data(neighbors,14)=oldGroups;
            elseif length(oldGroups)>1;
                for j=1:length(oldGroups)
                    data(data(:,14)==oldGroups(j),14)=groupNum;
                    data_full(data_full(:,14)==oldGroups(j),14)=groupNum;
                end
                data(neighbors,14)=groupNum;
                groupNum=groupNum+1;
                removedGroups=[removedGroups;oldGroups(:)];
            end
        else
            error('Missed a case');
        end
    end

%     fprintf('Match ratio : %g : %g seconds\n',sum(data_full(Time,14)==data(:,14))./size(data,1),toc)
    
    data_full(Time,14)=data(:,14);
    
%     toc
end

    groupNum=groupNum-1;


%% Remove empty groups

groupIndex=1;
for i=1:groupNum
    groupLoc=data_full(:,14)==i;
    if sum(groupLoc)>0;
        data_full(groupLoc,14)=groupIndex;
        groupIndex=groupIndex+1;
    end
end

groupNum=groupIndex-1;

dataGrouped=data_full;

end

% 
% 
% %% Graph
% 
% figure
% loc=data_full(:,8)<-139 & data_full(:,8)>-146 &...
%     data_full(:,7)<-33 & data_full(:,7)>-36;
% scatter(data_full(loc,8),data_full(loc,7),25,data_full(loc,14),'filled')
% 
% 
% % 
% % 
% % Storm=1972;
% % stormloc=dataGrouped(:,14)==Storm;
% % scatter(dataGrouped(stormloc,8),dataGrouped(stormloc,7),50,(datenum(dataGrouped(stormloc,1:6))-datenum(dataGrouped(1,1:3)))*24,'filled')
% axis equal
% axis tight
% colorbar('horiz')
% 
% %% Stats
% 
% clear timespan dist flashes
% index=1;
% for i=1:groupNum-1
%     if sum(dataGrouped(:,14)==i)>10
%         loc=dataGrouped(:,14)==i;
%         stormCenter=mean(dataGrouped(loc,7:8),1);
%         dist(index)=(rms(vdist(dataGrouped(loc,7),dataGrouped(loc,8),stormCenter(1),stormCenter(2))./1000));
%         lloc=find(loc);
%         timespan(index)=(datenum(dataGrouped(lloc(end),1:6))-datenum(dataGrouped(lloc(1),1:6)))*24;
%         flashes(index)=sum(loc);
%         index=index+1;
%     end
% end
% 
% timespan=timespan(timespan>0);
% dist=dist(dist>0);
% flashes=flashes(flashes>0);
% 
% 
% fprintf('Total storms : %g (%.02g%%)\n',index,100*index/groupNum);
% fprintf('Total singles : %g (%.02g%%)\n',groupNum-index,100*(groupNum-index)/groupNum);
% fprintf('Storm Time : %g +- %g minutes \n',median(60*timespan),mad(60*timespan));
% fprintf('Storm Area : %g +- %g km^2\n',median(pi*dist.^2),mad(pi*dist.^2));
% fprintf('Storm Flash Count : %g +- %g flashes\n',median(flashes),mad(flashes));
% 
% 
