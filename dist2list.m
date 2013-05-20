function [ list ] = dist2list( dist,base )
%dist2list takes a distribution and it's corresponding base and gives back 
%   a vector which produces the given distribution.
%
%   Written By:  Michael Hutchins

dist(isnan(dist))=0;
dist(isinf(dist))=0;

list=[];
for i=1:length(base);
    list=[list;repmat(base(i),round(dist(i)),1)];
end
list=list(:);
end

