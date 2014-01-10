function [ labels ] = sample_split( nElem, split )
%SAMPLE_SPLIT(nElem, split) assignes labels to a nElem length array with
%	frequency given by split
%	e.g. split = [0.8 0.1 0.1]
%	Will give a labels vector with 80% 1, 10% 2, 10% 3
%
%	Written by: Michael Hutchins

%% Check inputs

	if numel(nElem) ~= 1
		error('nElem needs to be a single number');
	end
	
	if sum(split) ~= 1
		warning('Split ratio does not sum to 1');
	end
	
%% Setup arrays

	labels = zeros(nElem,1);

	% Get the number of elements for each split
	nSplit = round(nElem * split);

	% Array of remaining indices
	remaining = 1 : nElem;

%% Loop for each split

	for i = 1 : length(nSplit)

		% Check that nSplit is <= to the remaining indices
		if nSplit(i) > length(remaining)
			nSplit(i) = length(remaining);
		end
		
		% Sample (without replacement) the remaining unassigned indices
		sample = randsample(length(remaining), nSplit(i));

		% Assign labels to the split number
		labels(sample) = i;

		% Remove assigned indices
		remaining(sample) = [];

	end

	% Set any remaining unassigned to the last index (usually from rounding
	% errors)
	labels(labels == 0) = i;

end

