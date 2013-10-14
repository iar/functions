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
	

	%% Define levels
			
	levelValues = squeeze(data(:,3,:));
	levelValues(levelValues == 0) = NaN;
	levelValues = nanmedian(levelValues,2);
	
	if logPlotting(3);
		levelValues = log10(levelValues);
	end
	
	levelRange = [min(levelValues), max(levelValues)];
	
	levels = linspace(levelRange(1), levelRange(2), nLevels + 1);
	
	%% Plot 
	
	keyboard
	
	figure
	
	nPlot = 2;
	mPlot = nLevels;
	pPlot = 1;
	
	% Top row: averaged data
	
	for i = 1 : nLevels
		
		subplot(nPlot, mPlot, pPlot);
		pPlot = pPlot + 1;
		
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
			semilogy(x,y);
		elseif logPlotting(2) & ~logPlotting(1)
			semilogx(x,y);
		elseif logPlotting(1) & logPlotting(2)
			loglog(x,y)
		else
			plot(x,y);
		end
		
		xlabel(names{2})
		ylabel(names{1})
		
		titleText = sprintf('%s: %.2g -- %.2g',...
							names{3},...
							level1, level2);
		
		title(titleText)
	end
	
	% Bottom row: total data


end