function [cores] = parallel_start( pools )
%PARALLEL_START spins up POOLS matlabpools or 1 per avaialble core if POOLS
%   is not specified.

    switch nargin
        case 0
            cores = feature('numcores');
        case 1
            cores = pools;
    end
    
    matlabpool(cores)

end

