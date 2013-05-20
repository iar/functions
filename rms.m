function [ RMS ] = rms( vector )
%Gives the Root-Mean-Square value
%
%   Written By:  Michael Hutchins

RMS=sqrt(mean(vector.^2));

end

