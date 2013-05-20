function [Power]=i2p(Ipeak)
%
%   Written By:  Michael Hutchins

Ipeak=abs(Ipeak);

Power=2240.*Ipeak.^(1.32);

end