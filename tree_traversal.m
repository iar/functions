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

	marked(tree == 0) = true;
	keyboard
	%% Traverse tree
	
	for i = 1 : size(tree,1)
		
		entries = tree(i,tree(i,:) > 0);

		if ~isempty(entries)
		
			if sum(marked(i,tree(i,:) > 0)) > 0
				first = tree(i,tree(i,:) > 0 & marked(i,:));
				first = first(end);
			else
				first = entries(1);
			end
		
			[tree, marked] = entry_update(i, tree, marked, first);
			
			groups(i) = first;
		
		end
		
	end

end

function [tree, marked] = entry_update(i, tree, marked, first)

	entries = tree(i, tree(i,:) > 0 & ~marked(i,:));
	
	if ~isempty(entries)
		
		for j = 1 : length(entries)
		
			update = tree == entries(j) & ~marked;
			
			tree(update) = first;
			marked(update) = true;
			
			newMembers = find(sum(update,2) > 0);
			
			for k = 1 : length(newMembers)
				try
				if sum(marked(newMembers(k),:) == 0) > 0
					[tree, marked] = entry_update(newMembers(k), tree, marked, first);
				end
				catch
					keyboard
				end
			end
				
		end
		
	end

end


