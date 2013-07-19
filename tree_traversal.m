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
			oldEntry = groupCell{entry(1)};
			
			groupCell{entry(1)} = [oldEntry,[i;0]];
			
		end
		
		eventCell{i} = [entries;zeros(1,length(entries))];
			
	end
	
	%% New Method

    groups = zeros(size(tree,1),1);


	for i = 1 : length(eventCell);

        mainEvent = eventCell{i};

		% Need a way to update mainEvent or something
		% Or remove it or use a sparse matrix
		
		if ~isempty(mainEvent)

			% Check to see if the stroke has been grouped before
			if sum(mainEvent(2,:)) > 0
				% If grouped before select the last group it was placed
				% into
				markedGroups = mainEvent(1,mainEvent(2,:) == 1);
                currentGroup = markedGroups(end);
			else
				% If never grouped before pick the first dbscan cluster
                currentGroup = mainEvent(1,1);
			end

			% Go through each group of mainEvent
			for j = 1 : size(mainEvent,2)

				% Get all members of each group
				groupMembers = groupCell{mainEvent(1,j)};
				
				for k = 1 : size(groupMembers,2)
				
					% Get the stroke number of each group member
					memberID = groupMembers(:,k);
					
					% Only process if it has yet to be grouped
					if memberID(2) == 0
						
						% Set the final groups number to the first one
						if groups(memberID(1)) == 0
							groups(memberID(1)) = currentGroup;
						end
						
						% Set the groupMember to be marked
						groupMembers(2,k) = 1;
						
						% Change the eventCell for the member for this
						% group to the currentGroup and mark it.
						newEventMembers = eventCell{memberID(1)};
						loc = newEventMembers(1,:) == mainEvent(1,j);
						if sum(loc) > 1
							newEventMembers = unique(newEventMembers','rows')';
							loc = newEventMembers(1,:) == mainEvent(1,j);
						end
						newEventMembers(:,loc) = [currentGroup;1];
						eventCell{memberID(1)} = newEventMembers;
					
					end
					
				end
				
				groupCell{mainEvent(1,j)} = groupMembers;

			end
			
		end

	end	

end

