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
	
	marked = false(size(tree,1),size(tree,2));
	
	%% Traverse tree
	
	for i = 1 : size(tree,1)
		
		entries = tree(i,tree(i,:) > 0);

		if ~isempty(entries)
		
			if sum(marked(i,:)) > 0
				first = tree(i,tree(i,:) > 0 & marked(i,:));
				first = first(end);
			else
				first = entries(1);
			end
		
			for j = 1 : length(entries)

				update = tree == entries(j) & ~marked;

				tree(update) = first;
				marked(update) = true;

			end

			groups(i) = first;
		
		end
		
	end

end

