function map_bin_plot(ndata,varargin)
%MAP_BIN_PLOT(ndata, options) takes in a global density array and returns a global contour
%map of the data. ndata generated from MAP_BIN.m
%   Options:
%     'Resolution',resolution - Override default resolution
%     'Stations',station_number - Plot stations on map
%     'Title',titletext - Give plot title 'titletext'
%     'Save',savename - save figure as 'savename'
%     'Log',true/false - Plots as log of the density (default true)
%     'Zoom' - Zooms view to ndata strokes
%     'ColorText',colorbartext - Set colorbar label
%     'ColorMax',cbarmax - Sets maximum colorbar to 10^cbarmax
%     'NoFigure' - does not create new figure (used for subplots)
%     'SmallTick',size - Sets tick marks at size degree resolution

%   2011/10/17 - Created by - Michael Hutchins
%   2011/10/20 - Updated options and print code

    Options=varargin;
    Log=true; 
    res=180/size(ndata,1);
    titletext=[];
    Save=false;
    savename=[];
    stationPlot=[];
    Zoom=false;
    colortext=[];
    NoFigure=false;
    SmallTick=false;
    ColorMax=false;
    ScreenSize=false;
    
    %strcmp(Options)
    for i=1:length(Options)
        if strncmp(Options{i},'Resolution',4)
            res=Options{i+1};
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
        elseif strncmp(Options{i},'ScreenSize',10);
            ScreenSize=true;
            screenPixel=Options{i+1};
        end
    end
    
    ndata=ndata+1;
    
    ndata(isinf(ndata))=NaN;

    [x,y] = meshgrid(-180+res/2:res:180-res/2,-90+res/2:res:90-res/2);
    xRange=x(1,nansum(ndata,1)>0);
    yRange=y(nansum(ndata,2)>0,1);

    if Log
        ndata=log10(ndata);
    end
    
    load coast
    stations
    
    pause(2.5);
    
    if NoFigure
        plot1=gcf;
    else
        plot1 = figure;
    end
    
    if ScreenSize
        set(plot1,'units','pixels','Position',[0,0,screenPixel(1),screenPixel(2)]);
    end
    
    pause(2.5);
    
    [C,h] = contourf(x,y,ndata);
    set(h,'EdgeColor','none');
    hold on
    scatter(station_loc(stationPlot+1,2),station_loc(stationPlot+1,1),100,'r^','Filled')
    plot(long,lat,'w');
    if SmallTick
        set(gca,'YTick',[-90:smalltick:90])
        set(gca,'XTick',[-180:smalltick:180])
    else
        set(gca,'YTick',[-90:30:90])
        set(gca,'XTick',[-180:60:180])
    end
    axis equal
    
    if Zoom
        xlim([xRange(1),xRange(end)]);
        ylim([yRange(1),yRange(end)]);
    else
        xlim([-180,180])
        ylim([-90,90])
    end
    xlabel('Longitude');
    ylabel('Latitude')
    h=colorbar;
    set(h,'Location','SouthOutside')
    set(gcf,'Color','w')
    
    if Log
        if ColorMax
            caxis([0,cbarmax])
            colormap(jet(cbarmax*3))
        else
            caxis([0,ceil(max(max(ndata)))])
            colormap(jet(ceil(max(max(ndata)))*3))
        end
    end
    if Log
        set(h,'XTick',[0:1:6],'XTickLabel',{'1','10','10^2','10^3','10^4','10^5','10^6'})
    end
    
    if isempty(colortext)
        colorbarText=sprintf('Stroke Density (strokes per %g degree x %g degree)    ',res,res);
    else
        colorbarText=colortext;
    end
    xlabel(h,colorbarText)
    title(titletext);
    Figures
    Figures(h)
    if Save
        if ScreenSize
            set(gcf,'PaperPositionMode','auto')
            print(gcf, '-dpng', savename);
        else
            saveas(gcf,savename);
        end
    end
end
