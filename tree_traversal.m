function [ groups ] = tree_traversal( tree )
%TREE_TRAVERSAL(tree) groups tree entries in a left-right manner returning 
%	a final list of groups across the tree
%
% Created by: Michael Hutchins

	groups = zeros(size(tree,1),1);
	
	marked = false(size(tree,1),size(tree,2));
	
	for i = 1 : 9% size(tree,1)
		
		entries = tree(i,tree(i,:) > 0);
		
		if sum(marked(:)) > 0
			first = tree(i,tree(i,:) > 0 & marked(i,:));
			first = first(end);
		else
			first = entries(1);
		end
			
		if ~isempty(entries)

			for j = 1 : length(entries)

				update = tree == entries(j) & ~marked;

				tree(update) = first;
				marked(update) = true;

			end

			groups(i) = first;
		
		end
		
	end

end

