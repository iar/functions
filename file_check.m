function [ exists ] = file_check( filename )
%file_check returns true if file filename exists

if exist(filename,'file')==2
    exists=true;
else
    exists=false;
end


end

