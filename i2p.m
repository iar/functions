function [Power]=i2p(Ipeak)

Ipeak=abs(Ipeak);

Power=2240.*Ipeak.^(1.32);

end