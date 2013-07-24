function [ groups ] = tree_traversal( tree )
%TREE_TRAVERSAL(tree) groups tree entries in a left-right manner returning 
%	a final list of groups across the tree
%
% Created by: Michael Hutchins

	%% Cut down the size of tree
	
	maxWidth = max(sum(tree>0,2));
	
	newTree = zeros(size(tree,1),maxWidth);
	
	for i = 1 : size(tree,1);
		
		entries = tree(i,tree(i,:) > 0);
	
		for j = 1 : length(entries)
			
			newTree(i,j) = entries(j);
			
		end
		
	end
	
	tree = newTree;
	
	%% Initialzie arrays

	groups = zeros(size(tree,1),1);

	%% Traverse tree
	
	for i = 1 : size(tree,1)
		
		entries = tree(i,tree(i,:) > 0);

		if ~isempty(entries)
		
			if groups(i) == 0
				groups(i) = entries(1);
			end

			first = groups(i);
			
			for j = 1 : length(entries)
				
				update = sum(tree == entries(j),2) > 0;
				
				nextStrokes = false(size(groups,1),1);
				nextStrokes(i : end) = true;
				
				groups(update & groups == 0) = first;
				
			end
			
		end
		
	end

end

