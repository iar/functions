function wwlln_plot( startDate, endDate, varargin )
%WWLLN_PLOT(ndata, options)
%   Options:
%     'Contour' - Plots as contour instead of density
%     'Resolution',resolution - Override default resolution
%     'Stations',station_number - Plot stations on map
%     'Title',titletext - Give plot title 'titletext'
%     'Save',savename - save figure as 'savename'
%     'Log',true/false - Plots as log of the density (default true)
%     'Zoom' - Zooms view to ndata strokes
%     'XWindow' - Set Xlim of plot
%     'YWindow' - Set Ylim of plot
%     'ColorText',colorbartext - Set colorbar label
%     'ColorMax',cbarmax - Sets maximum colorbar to 10^cbarmax
%     'ColorMin',cbarmin - Sets minumum colorbar to 10^cbarmax
%     'NoFigure' - does not create new figure (used for subplots)
%     'SmallTick',size - Sets tick marks at size degree resolution
%     'Blue' - Makes a bin of 0 strokes colorbar 0 instead of white
%     'Coast','high'/'low',color - Adjusts the coastlines plotted
%           high/low determines the level of detail
%           color specifies the color as matlab colorspec 'k' - black,
%                'w' - white 
%     'squareKM' - Plots in strokes/km^2/year, time is days spanned
%           by data

    Options=varargin;
    Contour = false;
    Log=true; 
    res=1;
    titletext=[];
    Save=false;
    savename=[];
    stationPlot=[];
    Zoom=false;
    colortext=[];
    NoFigure=false;
    SmallTick=false;
    ColorMax=false;
    ColorMin=false;
    ScreenSize=false;
    Blue=false;
    CoastColor='k';
    CoastDetail=1;
    xwin=false;
    ywin=false;
    km=false;
    
    %strcmp(Options)
    for i=1:length(Options)
        if strncmp(Options{i},'Resolution',4)
            res=Options{i+1};
        elseif strncmp(Options{i},'Contour',7)
            Contour = true;
        elseif strncmp(Options{i},'Stations',8)
            stationPlot=Options{i+1};
        elseif strncmp(Options{i},'Title',5)
            titletext=Options{i+1};
        elseif strncmp(Options{i},'Save',4)
            Save=true;
            savename=Options{i+1};
        elseif strncmp(Options{i},'Log',3)
            Log=Options{i+1};
        elseif strncmp(Options{i},'Zoom',4)
            Zoom=true;
        elseif strncmp(Options{i},'ColorText',9)
            colortext=Options{i+1};
        elseif strncmp(Options{i},'NoFigure',8)
            NoFigure=true;
        elseif strncmp(Options{i},'SmallTick',9)
            SmallTick=true;
            smalltick=Options{i+1};
        elseif strncmp(Options{i},'ColorMax',8)
            cbarmax=Options{i+1};
            ColorMax=true;
        elseif strncmp(Options{i},'ColorMin',8)
            cbarmin=Options{i+1};
            ColorMin=true;
        elseif strncmp(Options{i},'ScreenSize',10);
            ScreenSize=true;
            screenPixel=Options{i+1};
        elseif strncmp(Options{i},'Blue',4)
            Blue=true;
        elseif strncmp(Options{i},'Coast',5)
            if strncmp(Options{i+1},'high',4)
                CoastDetail=1;
            elseif strncmp(Options{i+1},'low',3)
                CoastDetail=0;
            elseif length(Options{i+1})==1
                CoastColor=Options{i+1};
            end
            if length(Options)>=i+2;
                if strncmp(Options{i+2},'high',4)
                    CoastDetail=1;
                elseif strncmp(Options{i+2},'low',3)
                    CoastDetail=0;
                elseif length(Options{i+2})==1
                    CoastColor=Options{i+2};
                end
            end
        elseif strncmp(Options{i},'XWindow',7)
            xwin=true;
            xwindow=Options{i+1};
        elseif strncmp(Options{i},'YWindow',7)
            ywin=true;
            ywindow=Options{i+1};
        elseif strncmp(Options{i},'squareKM',8)
            km=true;
        end
    end
        
    hold off
    
    %% Load Data
    
    start = floor(datenum(startDate));
    finish = floor(datenum(endDate));
    
    for i = start : finish
        data = ae_import(i);
        
        if i == start
            data = data(datenum(data(:,1:6)) >= datenum(startDate),:);
        elseif i == finish
            data = data(datenum(data(:,1:6)) <= datenum(endDate),:);
        end
        
        centers = {-180+res/2:res:180-res/2,-90+res/2:res:90-res/2};
        
        [ndata,c] = hist3([data(:,8),data(:,7)],'Ctrs',centers);% Extract histogram data
        
        if i == start
            dataSum = ndata;
        else
            dataSum = dataSum + ndata;
        end
    end
    
    data = dataSum';
    
    %% Adjust data
    
    % Set to strokes/km^2/year
    if km
        lat=[-90:res:90];
        latCenter=[-90+res/2:res:90-res/2];
        height=vdist(lat(1:end-1),ones(1,180/res),lat(2:end),ones(1,180/res))./1000;
        width=vdist(latCenter,zeros(1,180/res),latCenter,repmat(res,1,180/res))./1000;
        squareKM = repmat([width.*height]',1,360/res);
        
        years=(datenum(endDate) - datenum(startDate) + 1)./356;
        
        data=data./squareKM./years;
        
    end
    
    % Preformat meshgrid
    [x,y] = meshgrid(-180+res/2:res:180-res/2,-90+res/2:res:90-res/2);
    xRange=x(1,nansum(data,1)>0);
    yRange=y(nansum(data,2)>0,1);

    % Set data to log(data)
    if Log
        data=log10(data);
    end
    
    % Remove infs
    data(isinf(data))=NaN;

    
    %% Load Coast and Station Data
    
    if CoastDetail==1
        load coast_high
    elseif CoastDetail==0
        load coast
    end
    stations
    
    %% Create Figure
    
    if NoFigure
        plot1=gcf;
    else
        plot1 = figure;
    end
    
    if ScreenSize
        set(plot1,'units','pixels','Position',[0,0,screenPixel(1),screenPixel(2)]);
    end
    
    
    %% Plot Data
    
    
    if Contour
    
        [C,h] = contourf(x,y,data);
        set(h,'EdgeColor','none');
        hold on
        scatter(station_loc(stationPlot+1,2),station_loc(stationPlot+1,1),100,'r^','Filled')
        plot(long+res/2,lat+res/2,CoastColor);
 
    else
        
        imagesc(data);
        hold on
        set(gca,'YDir','normal')
        scatter((station_loc(stationPlot+1,2)+180-res/2)./res,(station_loc(stationPlot+1,1)+90-res/2)./res,100,'r^','Filled')
        plot((long+180-res/2)./res,(lat+90-res/2)./res,'k');
        
    end
        
    %% Format Figure
    
    axis equal
    set(gcf,'Color','w')

    %% Format Axis
    
    if Contour
    
        if SmallTick
            set(gca,'YTick',[-90:smalltick:90])
            set(gca,'XTick',[-180:smalltick:180])
        else
            set(gca,'YTick',[-90:30:90])
            set(gca,'XTick',[-180:60:180])
        end
        
    else
        
        if SmallTick
            
            set(gca,'XTick',[1:smalltick/res:360/res,360/res])
            set(gca,'YTick',[1:smalltick/res:180/res,180/res]) 
            set(gca,'XTickLabel',-180:smalltick:180)
            set(gca,'YTickLabel',-90:smalltick:90) 
        
        else
            set(gca,'XTick',[1:60/res:360/res,360/res])
            set(gca,'YTick',[1:30/res:180/res,180/res]) 
            set(gca,'XTickLabel',-180:60:180)
            set(gca,'YTickLabel',-90:30:90)             
        end
        
    end

    xlabel('Longitude');
    ylabel('Latitude')
            
    %% Format Zoom Window
    
    if Contour
    
        if Zoom
            xlim([xRange(1),xRange(end)]);
            ylim([yRange(1),yRange(end)]);
        else
            xlim([-180,180])
            ylim([-90,90])
        end
    
        if xwin
            xlim(xwindow);
        end
        if ywin
            ylim(ywindow);
        end
        
    else
      
        plot((long+180-res/2)./res,(lat+90-res/2)./res,'k');

    
        if Zoom
            xlim(([xRange(1),xRange(end)]+180-res/2)./res);
            ylim(([yRange(1),yRange(end)]+90-res/2)./res);
        else
            xlim(([-180,180]+180)./res)
            ylim(([-90,90]+90)./res)
        end
    
        if xwin
            xlim((xwindow+180-res/2)./res)
        end
        if ywin
            ylim((ywindow+90-res/2)./res)
        end        
    end
    
    %% Format colorbar range

    cLow=floor(min(data(:)));
    cHigh=ceil(max(data(:)));
    
    if ColorMax
        cHigh=cbarmax;
    end
        
    if ColorMin
        cLow=cbarmin;
    end
    
    if ColorMax || ColorMin
        if Log
            cMap=jet((cHigh-cLow)*3);
        else
            cMap=jet(cHigh-cLow);
        end
    else
        cMap=jet(ceil(max(max(data)))*3);
    end
   
    % Adjust for solid blue background
    if Blue
        set(gca,'Color',cMap(1,:))
    end
    
    h=colorbar;
    set(h,'Location','SouthOutside')
    caxis([cLow cHigh])
    colormap(cMap);
    
    %% Format colorbar text
        
    if isempty(colortext)
        if km
            colorbarText=sprintf('Stroke Density (strokes/km^2/year)    ');
        else
            colorbarText=sprintf('Stroke Density (strokes per %g degree x %g degree)    ',res,res);
        end
    else
        colorbarText=colortext;
    end
    xlabel(h,colorbarText)
    
    if Log
        set(h,'XTick',[-6:1:6],'XTickLabel',{'10^-6','10^-5','10^-4','10^-3','0.01','0.1','1','10','100','10^3','10^4','10^5','10^6'})
    end
    %% Set title

    title(titletext);
    
    %% Format fonts
    
    Figures
    Figures(h)
    
    %% Save
    if Save
        if ScreenSize
            set(gcf,'PaperPositionMode','auto')
            print(gcf, '-dpng', savename);
        else
            saveas(gcf,savename);
        end
    end
end

