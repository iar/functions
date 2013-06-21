function [ clusters ] = dbscan( D, eps, minPts )
%DBSCAN clustering of data D into clusters with distance less than eps and at least minPts members.
% http://en.wikipedia.org/wiki/DBSCAN
%
%	Written by: Michael Hutchins

	C = 0;
	points = size(D,1);
	visited = false(points,1);
	noise = visited;
	clusters = zeros(points,1);
	
	
	while sum(visited) < points
		
		% Select a point and mark it as visited
		P = find(~visited,1,'first');
		visited(P) = true;
		
		neighbors = regionQuery(P, D, eps);
		
		if length(neighbors) < minPts
			noise(P) = true;
		else
			C = C + 1;
			% Expand Cluster
			clusters(P) = C;
			index = 1;
			while index <= length(neighbors)
				try
				Pprime = neighbors(index);
				catch
					keyboard
				end
				if ~visited(Pprime)
					visited(Pprime) = true;
					neighborsPrime = regionQuery(Pprime, D, eps);
					if length(neighborsPrime) >= minPts
						neighbors = [neighbors; neighborsPrime];
						neighbors = unique(neighbors,'stable');
					end
				end
				if clusters(Pprime) == 0
					clusters(Pprime) = C;
				end
				index = index + 1;
			end
		end
	end
	
	clusters(noise) = 0;
				
end	
	

function [neighbors] = regionQuery(P, D, eps)
% regionQuery gets all the neighbors to P in dataset D

	nDim = size(D,2);
	
	distance = zeros(size(D,1),1);
	
	for i = 1 : nDim
		distance = distance + ((D(:,i) - D(P,i)).^2);
	end
	
	neighbors = find(distance < eps);
		
end

