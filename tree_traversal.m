function [ groups ] = tree_traversal( tree )
%TREE_TRAVERSAL(tree) groups tree entries in a left-right manner returning 
%	a final list of groups across the tree
%
% Created by: Michael Hutchins

	%% Remove completely empty columns (if present)
	
	tree(:,sum(tree,1) == 0) = [];

	%% Traverse 2 columns at a time
	
	while size(tree,2) > 1
		
		% Select first two columns
		branches = tree(:,1:2);
		tree(:,1:2) = [];
		
		% Label rows
		branches = [branches, [1 : size(branches,1)]'];
		
		% Remove [0 0] rows
		
		branches(all(branches(:,1:2) == 0,2),:) = [];
		
		% Traverse the branch
		
		newBranch = traverse(branches(:,1:2));
		
		% Expand newBranch to the size of tree
		
		branch = zeros(size(tree,1),1);
		branch(branches(:,3)) = newBranch;
		
		% Reduce branches to branch

		tree = [branch, tree];

	end

	groups = tree;
	
end
	
function [ groups ] = traverse(tree)
	
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

