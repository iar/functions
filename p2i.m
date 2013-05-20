function [Ipeak]=p2i(Power)
%
%   Written By:  Michael Hutchins

Ipeak=(Power./2240).^(1/1.32);

end