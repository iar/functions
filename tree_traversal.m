function [ groups ] = tree_traversal( tree )
%TREE_TRAVERSAL(tree) creates two lists of events per group and groups per event.
%	The events and groups are traversed to set similar groups together.
%
% Created by: Michael Hutchins


	%% Create group location list
	
	groupID = unique(tree(:));
	
	% GroupCell is a list of strokes in each group
	groupCell = cell(length(groupID) + 1,1);
	
	% Event cell is a list of groups for each stroke
	eventCell = cell(size(tree,1),1);
	
	% Populate the two cell lists
	for i = 1 : length(eventCell);
		
        entries = tree(i,tree(i,:) > 0);
		
		for j = 1 : length(entries)
			
			entry = [entries(j);0];
			oldEntry = groupCell{entry};
			
			groupCell{entry} = [oldEntry,i];
			
		end
		
		eventCell{i} = [entries;zeros(1,length(entries))];
			
	end
	
	%% New Method

    groups = zeros(size(tree,1),1);


	for i = 1 : length(eventCell);

        eventGroups = eventCell{i};

		% Need a way to update eventGroups or something
		% Or remove it or use a sparse matrix
		
		if ~isempty(eventGroups)

            if sum(eventGroups(2,:)) > 0
				markedGroups = eventGroups(1,eventGroups == 1);
                firstGroup = markedGroups(end);
            else
                firstGroup = eventGroups(1,1);
            end

            for j = 1 : size(eventGroups,2)

				newGroupMembers = groupCell{eventGroups(j)};
				
				for k = 1 : size(newGroupMembers,2)
				
					memberID = newGroupMembers(:,k);
					
					if memberID(2) == 0
						
						groups(memberID) = firstGroup;
						
						newGroupMembers(2,k) = 1;
						
					
					end
					
				end
				
				groupCell{eventGroups(j)} = newGroupMembers;

			end
			
		end

	end	

end

