function [ h ] = pairwise_plot( data, names )
%PAIRWISE_PLOT plots each pair of N variables in data (MxN) in a N x N
%	subplot figure. Names is a cell array with the names of each variable
%
%	Written by: Michael Hutchins

	%% Condition the input data
	
	%% Plotting variables

	N = size(data,2);

	nPlot = 1;
	
	%% Create plot
	
	h = figure;
	
	%% Plot data
	
	for i = 1 : N
		for j = 1 : N
			
			if i ~= j
				
				subplot(N,N,nPlot)
				
				plot(data(:,i),data(:,j),'.')
				
				xlabel(names{i})
				ylabel(names{j})
				
			end
				
			nPlot = nPlot + 1;
			
		end
	end
	
end

