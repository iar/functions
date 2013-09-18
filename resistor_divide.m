function [factor]=resistor_divide(R1,R2)
%RESISTOR_DIVIDE returns the resistor divider fraction from R1 and R2
%
%	Written by: Michael Hutchins

	factor=R2./(R1+R2);

end