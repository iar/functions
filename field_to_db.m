function [ db ] = field_to_db( field, reference)
%field_to_db converts field measurements to decibels
%
%   Written By:  Michael Hutchins

    switch nargin
        case 1
            reference = 1;
    end

    db = 20 .* log10(field ./ reference);

end

