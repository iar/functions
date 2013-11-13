function [ randNumber ] = randPDF( n, pdf )
%RANDPDF generates n random numbers that follow the given probably density
%	function PDF. PDF should be a 2 column vector with the basis and pdf
%	values
%
%	Written by: Michael Hutchins

%% Get cumulative distribution function

	cdf = cumsum(pdf(:,2));

%% Extract unique values of CDF (needs to be strictly monotonically increasing)

	[y,ia,ib] = unique(cdf);

	% Corresponding points in x
	x = pdf(ia,1);

%% Generate sample points spanning the range of y
	
	sample = min(y) + (max(y)-min(y)).*rand(n,1);

%% Select randomly from the inverted CDF

	randNumber = interp1(y,x,sample);

end

