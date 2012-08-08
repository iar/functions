function [ expanded ] = matrix_expand( matrix , integer)
%MATRIX_EXPAND Expands a matrix in size by a given integer
%   Given an N x M matrix, matrix_expand will convert it to
%   a integer * N x integer * M matrix with entries duplicated
%   to fill the new space. For example:
%   matrix=
%    0.3171    0.0344
%    0.9502    0.4387
%   integer=2
%   expanded=
%    0.3171    0.3171    0.0344    0.0344
%    0.3171    0.3171    0.0344    0.0344
%    0.9502    0.9502    0.4387    0.4387
%    0.9502    0.9502    0.4387    0.4387
%   Michael Hutchins - 7/21/2011

expanded=zeros(integer*size(matrix));

loc=expanded;
loc(1:integer:end,1:integer:end)=1;
loc=logical(loc);

for i=1:integer;
    for k=1:integer;
        expanded(circshift(loc,[i-1,k-1]))=matrix;
    end
end

end

