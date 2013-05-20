function [ hash ] = git_hash(directory)
%git_hash returns the git hash of the current commit for the current directory
%   The optinal argument directory will get the hash for the specified
%   location
%
%   Written By:  Michael Hutchins

    switch nargin
        case 0
            directory = pwd;
    end

    current_directory = pwd;
    cd(directory)
    [~,hash] = system('git rev-list --max-count=1 HEAD');
    cd(current_directory)

end

