function [ h ] = evolution_plot( data, names, logPlotting, nLevels )
%% EVOLUTION_PLOT plots the time series of data[:,1] vs data[:,2] split
%	over the level variable data[:,3].
%	nLevels are found, with the default of 4 levels
%
%	Written by: Michael Hutchins

	%% Data size
	
	N = size(data,1);
	M = size(data,2);
	P = size(data,3);
	
	if M == 2
		error('No level set defined')
	end
	
	imageN = 50;
	
	%% Condition the input data
	
	switch nargin
		case 1
			names = cell(M + 1,1);
			logPlotting = false(M + 1,1);
			nLevels = 4;
		case 2
			logPlotting = false(M + 1,1);
			nLevels = 4;
		case 3
			nLevels = 4;
	end
	
	logPlotting = logical(logPlotting);

	%% Define levels
			
	levelValues = squeeze(data(:,3,:));
	levelValues(levelValues == 0) = NaN;
	levelValues = nanmedian(levelValues,2);
	
	if logPlotting(3);
		levelValues = log10(levelValues);
	end
	
	levelRange = [min(levelValues), max(levelValues)];
	
	levels = linspace(levelRange(1), levelRange(2), nLevels + 1);
	
	levelColors = jet(nLevels);
	levelNames = cell(nLevels,1);
	
	%% Plot 
		
	figure
	
	nPlot =	2 * ceil(nLevels/3);
	mPlot = 3;
	pPlot = 1;
	
	%% Top plots: averaged data

	subplot(nPlot, mPlot, 1 : (nPlot/2) * mPlot);
	pPlot = pPlot + (nPlot/2) * mPlot;
	
	for i = 1 : nLevels
		
		
		level1 = levels(i);
		level2 = levels(i + 1);
		
		loc = levelValues >= level1 &...
			  levelValues <  level2;
		
		x = squeeze(data(loc,2,:));
		y = squeeze(data(loc,1,:));

		y(y == 0) = NaN;
		
		if logPlotting(1)
			y = nanmedian(y,1);
		else
			y = nanmean(y,1);
		end
		
		if P == 10
			x = 1 : 10;
		else
			xStep = x(1,2) - x(1,1);
			x = 0 : xStep : xStep * (length(y) - 1);

			x = x * 24;
		end
		
		if logPlotting(1) & ~logPlotting(2)
			semilogy(x,y,'Color',levelColors(i,:));
		elseif logPlotting(2) & ~logPlotting(1)
			semilogx(x,y,'Color',levelColors(i,:));
		elseif logPlotting(1) & logPlotting(2)
			loglog(x,y,'Color',levelColors(i,:))
		else
			plot(x,y,'Color',levelColors(i,:));
		end
		

		
		legendText = sprintf('%s: %.2g -- %.2g',...
							names{3},...
							level1, level2);
		levelNames{i} = legendText;
		
		if i == 1
			hold on
		end
		
	end
	
	title('Plot')
	legend(levelNames);
	xlabel(names{2})
	ylabel(names{1})
	
	%% Bottom plots: denisty plots of total data

	% Setup image bounds
	
	bounds = {};
	
	for i = 1 : M
		a = data(:,i,:);
		a = a(:);
		a = a(~isnan(a));
		bounds{i} = [prctile(a,5), prctile(a,95)];
	end
	
	for i = 1 : nLevels
		
		subplot(nPlot, mPlot, pPlot);
		pPlot = pPlot + 1;
		
		level1 = levels(i);
		level2 = levels(i + 1);
		
		loc = levelValues >= level1 &...
			  levelValues <  level2;
		
		%x = squeeze(data(loc,2,:));
		y = squeeze(data(loc,1,:));

		y(y == 0) = NaN;
		
		ySteps = axisSteps(bounds{1}, imageN, logPlotting(1));
		
		x = repmat([1 : P],size(y,1),1);
		
		for j = 1 : size(y,1);
			xSlice = x(j,:);
			ySlice = y(j,:);
			
			n = hist3([xSlice(:),ySlice(:)],{xSlice(:),ySteps});
			
			if j == 1
				levelDensity = n;
			else
				levelDensity = levelDensity + n;
			end
				
		end

		imagesc(xSlice,ySteps,log10(levelDensity)');

		set(gca,'YDir','Normal')

		if logPlotting(2)
			set(gca,'XTick',[]);
		end

		if logPlotting(1)
			set(gca,'YTick',[]);
		end

		title(levelNames{i})		
		
	end
	
end

function steps = axisSteps(bound, n, logBound)

	start = bound(1);
	stop = bound(2);
	
	if logBound
		
		steps = logspace(log10(start), log10(stop), n);
		
	else
		
		steps = linspace(start, stop, n);
		
	end

end