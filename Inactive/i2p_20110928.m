function [Power]=i2p(Ipeak)

Ipeak=abs(Ipeak);

Power=1676.51.*Ipeak.^(1.61933);

end