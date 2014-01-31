function [ list ] = dist2list( dist, base1, base2 )
%DIST2LIST(dist, base) takes a 1-D distribution and it's corresponding base
%	returns a vector which produces the given distribution.
%DIST2LIST(dist, base1, base2) takes a 2-D distribution and it's
%	corresponding bases and returns a vector which reproduces the given distribution
%	as a vector of (x,y) pairs.

%   Written By:  Michael Hutchins

	% If only 1 dimensional return a single call
	if nargin == 2
		list = distList(dist,base1);
		return
	end
	
	list = zeros(sum(dist(:)), 2);
	index = 1;
	
	for i = 1 : length(base2);
		
		X = distList(dist(:,i), base1);
		Y = repmat(base2(i),length(X),1);
		
		list(index : index + length(X) - 1,:) = [X, Y];
		
		index = index + length(X);
		
	end
	
end

function [list] = distList(dist, base)

	dist(isnan(dist))=0;
	dist(isinf(dist))=0;

	list=[];
	for i=1:length(base);
		list=[list;repmat(base(i),round(dist(i)),1)];
	end
	list=list(:);
end