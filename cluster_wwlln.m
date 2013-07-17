function [ storms ] = cluster_wwlln( data )
%CLUSTER_WWLLN takes in normally formatted WWLLN data returns a vector of
%	storm ID numbers for each stroke. Storm 0 strokes are ungrouped.

	%% clusters Parameters

		eps = .12;
		minPts = 3;
		timeScale = 9000;
		windowSize = 0.5;
		centerSize = 0.5;
			
	%% Convert time to distance
		seconds = datenum(data(:,1:6));
		seconds = seconds - min(seconds);
		seconds = seconds * 24*3600;
		seconds = seconds./timeScale;

	%% Format data
		D = [data(:,7),data(:,8), seconds];

	%% Set final storage array

		tree = zeros(size(D,1),50);
		clusters = zeros(size(E,1),1);
			
	%% Go through each time window
		
		windowIndex = 1;
	
		for j = 0 : windowSize : 24


			window = hours >= j - windowSize &...
					 hours <= j + centerSize + windowSize;

			center = hours >= j &...
					 hours <= j + centerSize;


			clusterHours = hours(window);

			clusterCenter =  clusterHours >= j &...
							 clusterHours <= j + centerSize;

			cluster = dbscan(D(window,:), eps, minPts);


			clusterOffset = cluster + max(clusters) + 1;
			clusterOffset(cluster == 0) = 0;			

			clusters(center) = clusterOffset(clusterCenter);
			tree(window,windowIndex) = clusterOffset;
			windowIndex = windowIndex + 1;
		end
			
% 		clusterTree = tree_traversal(tree);
		
	%% Renumber clusters
	
		% Could set to be clusterTree instead
		cluster = clusters(:);

		storm = zeros(length(cluster),1);
		
		stormID = unique(cluster);
		stormIndex = 1;
		
		for i = 1 : length(stormID);
			
			storm(cluster == stormID(i)) = stormIndex;
			stormIndex = stormIndex + 1;
			
		end
		
		storm(cluster == 0) = 0;
	
end

