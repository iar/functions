function [ groups ] = tree_traversal( tree )
%TREE_TRAVERSAL(tree) groups entries of the graph TREE through a graph
%traversal that follow the algorithm:
%
%	1. Pick first node
%	2. Get node ID or ID of first connected group
%		(i) Assign ID if not assigned
%	3. Get other nodes connected to each group
%	4. Assign ID of first node to all connected nodes
%	5. Repeat from (1) with next node in list
%
%	The algorithm is optimized by condensing TREE and creating an
%	invertedGraph that gives the nodes in each group
%
%	Current runtime is O(n^1.5)
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
	
	nodes = unique(tree(tree(:)>0));

	invertedTree = cell(max(nodes),1);
	
	for i = 1 : length(nodes);
		
		elements = find(sum(tree == nodes(i),2) > 0);

		invertedTree{nodes(i)} = unique(elements);
		
	end
	
%% Traverse tree and invertedTree

	groups = traverse(tree, invertedTree);
	
end
	
function [ IDs ] = traverse(graph, invertedGraph)
	
	%% Initialzie node ID array

	IDs = zeros(size(graph,1),1);

	%% Array of nodes to update
	
	needID = 1 : size(graph,1);
	
	%% Traverse graph
	
	for i = 1 : size(graph,1)
		
		% Get node groups
		groups = graph(i,graph(i,:) > 0);

		% If not connected continue
		if isempty(groups)
			continue
		end
		
		% If ID not assigned, set to first group
		if IDs(i) == 0
			IDs(i) = groups(1);
		end

		% Set ID to ID of node_i
		ID = IDs(i);

		% Go through members of each group
		for j = 1 : length(groups)

			% Get nodes within group(j)
			nodes = invertedGraph{groups(j)};

			% Find intersection of nodes in group and nodes to update			
			update = ismembc(nodes, needID);
			
			% Assign unassigned IDs to ID of node_i
			IDs(nodes(update)) = ID;
	
		end
			
	end	

end

