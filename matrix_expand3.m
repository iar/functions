function [ expanded ] = matrix_expand3( matrix , integer)
%MATRIX_EXPAND Expands a matrix in size by a given integer in the 3rd
%dimension
%   Given an N x M x P matrix, matrix_expand will convert it to
%   an N x M x integer * P matrix with entries duplicated
%   to fill the new space.
%   Michael Hutchins - 6/13/2012

expanded=zeros(size(matrix,1),size(matrix,2),size(matrix,3)*integer);

for i = 1:size(matrix,3)
    for j = 1:integer;
        expanded(:,:,j+(i-1)*integer)=matrix(:,:,i);
    end
end