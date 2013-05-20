function [cores] = parallel_start
%PARALLEL_START spins up 1 matlabpool per available processor core.

    cores = feature('numcores');
    matlabpool(cores)

end

