function lightningPlot( data , varargin )
%lightningPlot takes in WWLLN formatted data and genrates a global plot.

%% Load coastal data
    load coast_high

%% Read input parameters
    
    crop = false;
    density = false;
    
    res = 0.5;
    
    for i=1:length(varargin)
        if strncmp(varargin{i},'Crop',4)
            crop = true;
        elseif strncmp(varargin{i},'Density',7)
            density = true;
        elseif strncmp(varargin{i},'Resolution',3)
            res = varargin{i + 1};
        end
    end

    if density        
        if crop
            limX = ([min(data(:,8)) max(data(:,8))]+180)/res;
            limY = ([min(data(:,7)) max(data(:,7))]+90)/res;
        else
            limX = [0 360/res];
            limY = [0 180/res];
        end
        
        long = (long + 180 + 1)/res;
        lat = (lat + 90 + 1)/res;
        
    else
        if crop
            limX = [min(data(:,8)) max(data(:,8))];
            limY = [min(data(:,7)) max(data(:,7))];
        else
            limX = [-180 180];
            limY = [-90 90];
        end
    end

%% Plot strokes
    
    hold off

    if density
        n = hist3([data(:,8) data(:,7)],'Edges',{[-180:res:180],[-90:res:90]});
        imagesc(log10(n)')
        set(gca,'Ydir','Normal')
    else
        plot(data(:,8),data(:,7),'.')
    end
    
    
%% Plot coastlines
    hold on
    
    plot(long,lat,'k')
    
%% Format plot
    daspect([1 1 1])
    xlabel('Longitude')
    ylabel('Latitude')

    xlim(limX)
    ylim(limY)

end

