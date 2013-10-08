function [ h ] = pairwise_plot( data, names, logPlotting )
%% PAIRWISE_PLOT plots each pair of N variables in data (MxN) in a N x N
%	subplot figure. Names is a cell array with the names of each variable.
%	Upper plots are point plots and lower plots are density plots
%	LogPlotting is a logical array designating which variables N should be
%	plotting on a log scale.
%
%	Written by: Michael Hutchins

	%% Data size
	
	N = size(data,2);
	M = size(data,1);

	%% Condition the input data
	
	switch nargin
		case 1
			names = cell(N,1);
			logPlotting = false(N,1);
		case 2
			logPlotting = false(N,1);
	end
	
	%% Plotting variables

	logPlotting = logical(logPlotting);
	
	nPlot = 1;
	
	%% Get plot bounds
	
	bounds = {};
	
	for i = 1 : N
		bounds{i} = [min(data(:,i)), max(data(:,i))];
	end
		
		
	%% Create plot
	
	h = figure;
	
	%% Plot data
	
	for j = 1 : N
		for i = 1 : N
			
			if i ~= j
				
				subplot(N,N,nPlot)
				
				if i > j
				
					if logPlotting(i) && logPlotting(j)
						
						loglog(data(:,i),data(:,j),'.');
						
					elseif logPlotting(i)
						
						semilogx(data(:,i),data(:,j),'.')
						
					elseif logPlotting(j)
						
						semilogy(data(:,i),data(:,j),'.')
						
					else
					
						plot(data(:,i),data(:,j),'.')
						
					end
					
					xlim(bounds{i})
					ylim(bounds{j})

					xlabel(names{i})
					ylabel(names{j})
					
				else
										
					xSteps = axisSteps(bounds{i}, floor(M/10), logPlotting(i));
					ySteps = axisSteps(bounds{j}, floor(M/10), logPlotting(j));

					n = hist3(data(:,[i,j]),{xSteps,ySteps});
					
					imagesc(xSteps,ySteps,n');
					set(gca,'YDir','Normal')
					
					if logPlotting(i)
						set(gca,'XScale','log')
						set(gca,'XTick',10.^(unique(floor(log10(xSteps)))));
					end
					
					if logPlotting(j)
						set(gca,'YScale','log')
						set(gca,'YTick',10.^(unique(floor(log10(ySteps)))));
					end
	
					xlabel(names{i})
					ylabel(names{j})

				end
			end
				
			nPlot = nPlot + 1;
			
		end
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