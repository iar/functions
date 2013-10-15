function [ levelMean, levelDensity ] = level_plot( data, names, logPlotting, nLevels, varSteps )
%% LEVEL_PLOT plots the time series of data[:,1] vs data[:,2] split
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
			varSteps = [P, 10];
		case 2
			logPlotting = false(M + 1,1);
			nLevels = 4;
			varSteps = [P, 10];
		case 3
			nLevels = 4;
			varSteps = [P, 10];
		case 4
			varSteps = [P, 10];
	end
	
	logPlotting = logical(logPlotting);

	%% Set variables
	
	x = squeeze(data(:,1,:));
	x = x(:);
	
	y = squeeze(data(:,2,:));
	y = y(:);
	
	z = squeeze(data(:,3,:));
	z = z(:);
	
	%% Define levels
			
	[levels, levelRange] = levelDef(z, logPlotting(3), nLevels);
	
	levelColors = jet(nLevels);
	levelText = cell(nLevels,1);
	
	%% Define x and y basis
	
	[xBase, xRange] = levelDef(x, logPlotting(1), varSteps(1));
	[yBase, yRange] = levelDef(y, logPlotting(2), varSteps(2));
	
	xStep = xBase(end) - xBase(end-1);
	
	%% Format data

	levelDensity = zeros(length(xBase),length(yBase),nLevels);
	levelMean	 = zeros(length(xBase),nLevels);
	
	for i = 1 : nLevels;
		
		level1 = levels(i);
		level2 = levels(i + 1);
		
		loc = z >= level1 &...
			  z <  level2;
		  
		xLevel = x(loc);
		yLevel = y(loc);
		
		for j = 1 : length(xBase) 
			
			if j == length(xBase)
				xLoc = xLevel >= xBase(j) &...
				   xLevel < xBase(j) + xStep;
			else
				xLoc = xLevel >= xBase(j) &...
				   xLevel < xBase(j + 1);
			end

			
			yHist = hist(yLevel(xLoc),yBase);
			
			levelDensity(j,:,i) = yHist;
			
			if logPlotting(1)
			
				levelMean(j,i) = nanmedian(yLevel(xLoc));
				
			else
		
				levelMean(j,i) = nanmean(yLevel(xLoc));
			end
				
		end
		
		legendText = sprintf('%s: %.2g -- %.2g',...
							names{3},...
							level1, level2);
		levelText{i} = legendText;
		
	end
	
	%% Plot 
		
	figure
	
	nPlot =	2 * ceil(nLevels/3);
	mPlot = 3;
	pPlot = 1;
	
	
	%% Top plots: averaged data

	subplot(nPlot, mPlot, 1 : (nPlot/2) * mPlot);
	pPlot = pPlot + (nPlot/2) * mPlot;
	
	for i = 1 : nLevels
		
		if logPlotting(1) & ~logPlotting(2)
			
			semilogx(xBase,levelMean(:,i),'Color',levelColors(i,:));
			
		elseif logPlotting(2) & ~logPlotting(1)
			
			semilogy(xBase,levelMean(:,i),'Color',levelColors(i,:));
			
		elseif logPlotting(1) & logPlotting(2)
			
			loglog(xBase,levelMean(:,i),'Color',levelColors(i,:))
			
		else
			
			plot(xBase,levelMean(:,i),'Color',levelColors(i,:));
			
		end
		
		if i == 1
			hold on
		end
		
	end
	
	title('Plot')
	legend(levelText);
	xlabel(names{1})
	ylabel(names{2})
	
	%% Bottom plots: denisty plots of total data


	for i = 1 : nLevels
		
		subplot(nPlot, mPlot, pPlot);
		pPlot = pPlot + 1;
		
		if logPlotting(1) & ~logPlotting(2)
			
			imagesc(log10(xBase),yBase,log10(squeeze(levelDensity(:,:,i))'));
			
		elseif logPlotting(2) & ~logPlotting(1)
			
			imagesc(xBase,log10(yBase),log10(squeeze(levelDensity(:,:,i))'));
			
		elseif logPlotting(1) & logPlotting(2)
			
			imagesc(log10(xBase),log10(yBase),log10(squeeze(levelDensity(:,:,i))'));
			
		else
			
			imagesc(xBase,yBase,log10(squeeze(levelDensity(:,:,i))'));
			
		end		
		imagesc(xBase,yBase,log10(squeeze(levelDensity(:,:,i))'));

		set(gca,'YDir','Normal')

		if logPlotting(2)
			set(gca,'XTick',[]);
		end

		if logPlotting(1)
			set(gca,'YTick',[]);
		end

		title(levelText{i})		
		xlabel(names{1})
		ylabel(names{2})
	end
	
end

function [levels, levelRange] = levelDef(data, logLevel, nLevels)

	levelValues = squeeze(data);
	levelValues = levelValues(:);
	
	if logLevel
		levelValues = log10(levelValues);
	end
	
	levelRange = [min(levelValues), max(levelValues)];
	
	levels = linspace(levelRange(1), levelRange(2), nLevels + 1);
	
	if logLevel
		levels = 10.^levels;
		levelRange =  10.^levelRange;
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