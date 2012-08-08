function [median_error]=mmad(X)
%mmad calculates the median absolute error of the values in X

median_error=median(abs(X-median(X)));

end