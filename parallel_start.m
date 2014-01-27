function [cores] = parallel_start( pools )
%PARALLEL_START spins up POOLS matlabpools or 1 per avaialble core if POOLS
%   is not specified.
%
%   Written By:  Michael Hutchins

    switch nargin
        case 0
            cores = feature('numcores');
        case 1
            cores = pools;
    end
   
    % Check for license limitations
    if cores > 8
	cores = 8;
    end
 
    currentPool = matlabpool('size');
    
    if currentPool == 0
		matlabpool(cores);
    elseif currentPool ~= cores
        matlabpool close
        matlabpool(cores)
    end

end

