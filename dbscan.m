function [ output_args ] = dbscan( D, eps, minPts )
%DBSCAN clustering of data D into clusters with distance less than eps and at least minPts members.
% http://en.wikipedia.org/wiki/DBSCAN
%
%	Written by: Michael Hutchins

	C = 0;
	points = size(D,1);
	visited = false(points,1);
	noise = visited;
	unvisited = [1 : points];
	
	while sum(visited) < points
		
		% Select a point and mark it as visited
		P = unvisited(1);
		visited(P) = true;
		unvisited(P) = [];
		
		neighbors = regionQuery(P, D, eps);
		
		if length(neighbors) < minPts
			noise(P) = true;
		else
			C = C + 1;
			epandCluster(P, neighbors, C, eps, minPts)
		
	end	
	

end

function [neighbors] = regionQuery(P, D, eps)
% regionQuery gets all the neighbors to P in dataset D

	nDim = size(D,2);
	
	distance = zeros(size(D,1),1);
	
	for i = 1 : nDim
	
		distance = distance + ((D(:,i) - D(P,:)).^2);
		
	end
	
	neighbors = find(distance < eps);
	
end

