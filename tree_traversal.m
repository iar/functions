function [ cluster ] = tree_traversal( tree )
%TREE_TRAVERSAL(tree) creates two lists of events per group and groups per event.
%	The events and groups are traversed to set similar groups together.
%
% Created by: Michael Hutchins


	%% Create group location list
		
	graph = false(size(tree,1),max(tree(:)));
	
	for i = 1 : size(graph,1);
		
        entries = tree(i,tree(i,:) > 0);
		
		for j = 1 : length(entries)
			
			entry = entries(j);

			graph(i,entry) = true;
			
		end
		
	end
	
	%% New Method

	marked = false(size(graph,1),size(graph,2));
	
	for i = 1 : size(graph,1);

        groups = find(graph(i,:));
		marks = marked(i,:);
		
		if ~isempty(groups)

			if ~any(marks);
				marks(groups(1)) = true;
			end

			for j = 1 : length(groups)

				check = groups(j);

				update = graph(:,check) & ~marked(:,check);
				marked(update,:) = repmat(marks,sum(update),1);

			end
		
		end
	end
	
	%% Extract final groups
	
    cluster = zeros(size(tree,1),1);
	
	for i = 1 : size(marked,1)
		
		cluster(i) = find(marked(i,:));
		
	end
		
end

