function [ area ] = areaMap( resolution )
%AREAMAP Generates a map of the area per degree resolution in square kilometers
%
%   Written By:  Michael Hutchins

res=resolution;
area=zeros(180/res,1);
index=1;
offset=0.000001; % Used to prevent bugs in vdist.
for i = -90:res:90-res
    width=vdist(i,offset,i,res)/1000;
    height=vdist(i,offset,i+res-offset,offset)/1000;
    area(index)=width*height;
    index=index+1;
end
area=repmat(area,1,360/res);
area=real(area);
end

