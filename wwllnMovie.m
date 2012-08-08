function wwllnMovie(startDate,endDate,varargin)
%%wwllnMovie makes an animated .gif file of WWLLN density data for the date
%%range specified by startDate and endDate with the following options:
%   Note: startDate and endDate can be date vectors [yyyy,mm,dd] or a
%   matlab datenum number
%   Options:
%         'Resolution',resolution - specify density resolution in degrees
%         'TimeStep',timestep - time step between frames in hours
%         'Zoom',latBox,longBox - just plot a region specified by latBox and 
%             longBox. i.e. latBox=[25,45],longBox=[-130,-90]
%         'ScreenSize',screensize - Sets output filesize to [width,height] pixels
%         'FrameSpeed',speed - time spent on each frame in ms
%         'OutputName',outputname - Output file name, defaults to WWLLN.gif
%         'DE' - Factors in the relative detection efficiency into the
%               counts
%         'MapOptions',{map_options} - A cell array of map options:
%               'SmallTick',size - Sets tick marks at size degree resolution
%               'Blue' - Makes a bin of 0 strokes colorbar 0 instead of white
%               'Coast','high'/'low',color - Adjusts the coastlines plotted
%                       high/low determines the level of detail
%                       color specifies the color as matlab colorspec i.e.
%                       'k' - black, 'w' - white 
%               'Stations',station_number - Plot stations on map


% %File Dependencies:
%     a_import.m - Import WWLLN A-files
%     map_bin.m - Bins WWLLN data
%         Mapping Toolbox
%     map_bin_plot.m 
%         coast_high.mat
%         stations.m
%             stations.mat
%             station_import.m
%         Figures.m
%     convert (from ImageMagick software)
    
%   10/20/2011 - Created - Michael Hutchins
%   10/21/2011 - Addded in detection efficiency
%   10/24/2011 - Added in MapOptions

    if length(startDate)==1;
        date=datevec(startDate);
        startDate=date(1:3);
    end
    if length(endDate)==1;
        date=datevec(endDate);
        endDate=date(1:3);
    end

    resolution=2.5;
    TimeStep=1;
    Zoom=false;
    ScreenSize=[800,600];
    FrameSpeed=200;
    OutputName='WWLLN.gif';
    DE=false;
    MapOptions={};
    de_path='Detection_Efficiency/deMaps/';
    
    Options=varargin;

    for i=1:length(Options)
        if strncmp(Options{i},'Resolution',7)
            resolution=Options{i+1};
        elseif strncmp(Options{i},'TimeStep',8)
            TimeStep=Options{i+1};
        elseif strncmp(Options{i},'Zoom',4)
            Zoom=true;
            latBox=Options{i+1};
            longBox=Options{i+2};
        elseif strncmp(Options{i},'ScreenSize',10)
            ScreenSize=Options{i+1};
        elseif strncmp(Options{i},'FrameSpeed',10)
            FrameSpeed=Options{i+1};
        elseif strncmp(Options{i},'OutputName',10)
            OutputName=Options{i+1};
        elseif strncmp(Options{i},'DE',2)
            DE=true;
        elseif strncmp(Options{i},'MapOptions',10)
            MapOptions=Options{i+1};
        end
    end

    fileIndex=1;
    
    %% Generate movie images
    
    if TimeStep<12
        cbarmax=4;
    else
        cbarmax=5;
    end
    
    %Load Detection efficiency data
    
    for i=datenum(startDate):datenum(endDate)
        data=a_import(i);
        dataTime=(datenum(data(:,1:6))-datenum(data(1,1:6)))*24;
        if DE
            deFile=sprintf('%sDE%04g%02g%02g',de_path,data(1,1:3));
            load(deFile);
        end
        for j=0:TimeStep:24-TimeStep
            loc=dataTime>=j & dataTime<j+TimeStep;
            dataStep=data(loc,:);
            if Zoom
                loc=dataStep(:,7)>=latBox(1) &...
                    dataStep(:,7)<=latBox(2) &...
                    dataStep(:,8)>=longBox(1) &...
                    dataStep(:,8)<=longBox(2);
                dataStep=dataStep(loc,:);
            end
            n=map_bin(dataStep,'Resolution',resolution);
            hour=floor(j);
            if DE
                if TimeStep>1
                    de=squeeze(mean(de_map,3))';
                else
                    de=de_map(:,:,hour+1)';
                end
                de=matrix_expand(de,round(size(n,1)/size(de,1)));
                n=n./de;
            end
            minute=(j-floor(j))*60;
            titleText=sprintf('WWLLN Stroke Density - %04g/%02g/%02g %02g:%02g',dataStep(1,1:3),hour,minute);
            saveName=sprintf('Movie/MovieTemp%06g.png',fileIndex);                
            
            if Zoom
                map_bin_plot(n,'Title',titleText,'Save',saveName,'ScreenSize',ScreenSize,'ColorMax',cbarmax,'Zoom',MapOptions{:});
            else
                map_bin_plot(n,'Title',titleText,'Save',saveName,'ScreenSize',ScreenSize,'ColorMax',cbarmax,MapOptions{:});
            end
            fileIndex=fileIndex+1;
            close all;
            fclose all;
        end
    end
    
    %% Generate animated .gif
    
    movieCommand=sprintf('!/usr/local/bin/convert -adjoin -delay %g Movie/MovieTemp*.png %s',FrameSpeed/10,OutputName);
    
    eval(movieCommand)

    !rm Movie/MovieTemp*png

end