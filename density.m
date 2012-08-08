function [h] = density(X,Y,varargin)
%DENSITY results in a density plot given by the two vectors
%   Uses imagesc but allows for better control of spacing
%       logy
%       logx
%       logn
%       xspace - either spacing vector or number of bins
%       yspace - either spacing vector or number of bins
%       nofigure - plots in current figure
%   Created 1/24/2012 - Michael Hutchins

    Options=varargin;

    logx=false;
    logy=false;
    logn=false;
    xspace=10;
    yspace=10;
    xbins=true;
    ybins=true;
    newFigure=true;
    
    %strcmp(Options)
    for i=1:length(Options)
        if strncmp(Options{i},'logx',4)
           logx=true;
        elseif strncmp(Options{i},'logy',4)
           logy=true;
        elseif strncmp(Options{i},'logn',4)
           logn=true;
        elseif strncmp(Options{i},'xspace',6)
           if length(Options{i+1})==1;
               xspace=Options{i+1};
               xbins=true;
           elseif length(Options{i+1})>1;
               xspace=Options{i+1};
               xbins=false;
           else
               error('XSpace not specified')
           end
        elseif strncmp(Options{i},'yspace',6)
           if length(Options{i+1})==1;
               yspace=Options{i+1};
               ybins=true;
           elseif length(Options{i+1})>1;
               yspace=Options{i+1};
               ybins=false;
           else
               error('YSpace not specified')
           end
        elseif strncmp(Options{i},'nofigure',8)
            newFigure=false;
        end
    end


    %% Generate X and Y spacing
    
    if xbins
        maxX=ceil(max(X));
        minX=floor(min(X));
        numX=xspace;
        delX=round((maxX-minX)/numX);

        if ~logx
            xspace=[minX:delX:maxX];
        elseif logx
            xspace=logspace(floor(log10(minX)),ceil(log10(maxX)),numX);
        end
    end
    
    if ybins
        maxY=ceil(max(Y));
        minY=floor(min(Y));
        numY=yspace;
        delY=round((maxY-minY)/numY);

        if ~logy
            yspace=[minY:delY:maxY];
        elseif logy
            yspace=logspace(floor(log10(min(Y))),ceil(log10(max(Y))),numY);
        end    
    end
    
%     if ybins & ~logy
%         yspace=[min(Y):(max(Y)-min(Y))/yspace:max(Y)];
%     elseif ybins & logy
%         yspace=logspace(log10(min(Y)),log10(max(Y)),yspace);
%     end
    
    %% Create density map
    
    X=X(:);
    Y=Y(:);
    
    n=hist3([X,Y],{xspace,yspace});
    
    %% Plot
    
    if newFigure
        figure;
    end
    if logn
        imagesc(log10(n)');
    else
        imagesc(n');
    end
    set(gca,'YDir','Normal');
    set(gca,'XTick',[1:round(length(xspace)/5):length(xspace)],'XTickLabel',xspace(1:round(length(xspace)/5):end));
    set(gca,'YTick',[1:round(length(yspace)/5):length(yspace)],'YTickLabel',yspace(1:round(length(yspace)/5):end));

    Figures;
    
%%  
%%  
