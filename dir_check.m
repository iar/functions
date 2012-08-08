function [ exists ] = dir_check( directory )
%file_check returns true if file filename exists

if exist(directory,'dir')==7
    exists=true;
else
    exists=false;
end


end

