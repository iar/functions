function [ parallel ] = parallel_check
%PARALLEL_CHECK returns true if parallel computing toolbox is installed

    A = ver;
    
    parallel = false;
    
    for i = 1 : length(A);
        if strncmp(A(i).Name,'Parallel Computing Toolbox',26);
            parallel = true;
        end
    end



end

