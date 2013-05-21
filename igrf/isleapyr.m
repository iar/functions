function leapyr = isleapyr(yr)

% ISLEAPYR Test for leap year.
% 
% Usage: LEAPYR = ISLEAPYR(YR)
% 
% Test if a year is a leap year. The rules are as follows:
%    Is YR divisible by 4?
%       Yes = Is YR divisible by 100?
%           Yes = Is YR divisibly by 400?
%               Yes = YR is a leap year.
%               No = YR is not a leap year
%           No = YR is a leap year
%        No = YR is not a leap year
% 
% Input:
%   -YR: Year to test for leap year. YR can be a scalar or matrix.
% 
% Output:
%   -LEAPYR: For each element in YR, 1 if it is a leap year, 0 otherwise.

leapyr = (~mod(yr, 4) & mod(yr, 100)) | (~mod(yr, 400));