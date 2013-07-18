function [ groups ] = tree_traversal( tree )
%TREE_TRAVERSAL(tree) creates two lists of events per group and groups per event.
%	The events and groups are traversed to set similar groups together.
%
% Created by: Michael Hutchins


	%% Create group location list
	
	groupID = unique(tree(:));
	
	groupCell = cell(length(groupID) + 1,1);
	eventCell = cell(size(tree,1),1);
	
	for i = 1 : length(eventCell);
		
        entries = tree(i,tree(i,:) > 0);
		
		for j = 1 : length(entries)
			
			entry = entries(j);
			oldEntry = groupCell{entry};
			
			groupCell{entry} = [oldEntry,i];
			
		end
		
		eventCell{i} = entries;
			
	end
	
	%% New Method

    groups = zeros(size(tree,1),1);

    set = false(size(tree,1),1);

	for i = 1 : length(eventCell);

        eventGroups = eventCell{i};

		if ~isempty(eventGroups)

            if set(i)
                firstGroup = groups(i);
            else
                firstGroup = eventGroups(1);
            end

            for j = 1 : length(eventGroups)

				newGroupMembers = groupCell{eventGroups(j)};
				
				for k = 1 : length(newGroupMembers)
				
					memberID = newGroupMembers(k);
					
					if ~set(memberID)
						
						groups(memberID) = firstGroup;
						set(memberID) = true;
					
					end
					
				end

            end

		end

	end	

end

