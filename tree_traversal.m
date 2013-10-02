function [ groups ] = tree_traversal( tree )
%TREE_TRAVERSAL(tree) groups entries of the tree graph in a left-right
%	manner returning a final list of groups across the tree graph
%
% Created by: Michael Hutchins

%% Remove completely empty columns (if present)
	
	tree(:,sum(tree,1) == 0) = [];

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
	
%% Create inverted tree (strokes belonging to groups)

	n = hist(tree(tree(:)>0),max(tree(tree(:)>0)));
	
	nodes = unique(tree(tree(:)>0));

	invertedTree = cell(max(nodes),1);
	
	for i = 1 : length(nodes);
		
		elements = find(sum(tree == nodes(i),2) == 1);
		
		invertedTree{i} = elements;
		
	end
	
%% Traverse tree and invertedTree

	groups = traverse(tree, invertedTree);
	
end
	
function [ groups ] = traverse(tree, invertedTree)
	
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
				
				% Get members to assign groups

				members = invertedTree{entries(j)};

				update = false(length(groups),1);
				update(members) = true;				
				
				% Assign unassigned groups to first
				groups(update & groups == 0) = first;
				
				% Add members to group first

				invertedTree{first} = unique([invertedTree{first}; members]);
				
			end
			
		end
		
	end
	

end

