function [ h ] = pairwise_plot( data, names )
%% PAIRWISE_PLOT plots each pair of N variables in data (MxN) in a N x N
%	subplot figure. Names is a cell array with the names of each variable.
%	Upper plots are point plots and lower plots are density plots
%
%	Written by: Michael Hutchins

	%% Condition the input data
	
	%% Plotting variables

	N = size(data,2);
	M = size(data,1);
	
	nPlot = 1;
	
	%% Get plot bounds
	
	bounds = {};
	
	for i = 1 : N
		bounds{i} = [min(data(:,i)), max(data(:,i))];
	end
		
		
	%% Create plot
	
	h = figure;
	
	%% Plot data
	
	for i = 1 : N
		for j = 1 : N
			
			if i ~= j
				
				subplot(N,N,nPlot)
				
				if i < j
				
					plot(data(:,i),data(:,j),'.')

					xlim(bounds{i})
					ylim(bounds{j})

					xlabel(names{i})
					ylabel(names{j})
					
				else
					
					xSteps = axisSteps(bounds{i}, floor(M/10));
					ySteps = axisSteps(bounds{j}, floor(M/10));

					n = hist3([data(:,[i,j])],{xSteps,ySteps});
					
					imagesc(xSteps,ySteps,n);
					set(gca,'YDir','Normal')
	
					xlabel(names{j})
					ylabel(names{i})

				end
			end
				
			nPlot = nPlot + 1;
			
		end
	end
	
end

function steps = axisSteps(bound, n)

	start = bound(1);
	stop = bound(2);
	
	step = (stop - start) / n;
	
	steps = start : step : stop;

end