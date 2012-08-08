function [padded]=pad(array,pad,direction)
%PAD adds zeros to an array in the direction given for the amount specified

%   2011/10/17 - Michael Hutchins

arraySize=size(array);
for i=1:length(arraySize);
    loc(i)=i;
end
paddingLoc=loc~=direction;
padding=zeros(size(paddingLoc));

padding(paddingLoc)=arraySize(paddingLoc);
padding(padding==0)=pad;
padZero=zeros(padding);

padded=cat(direction,array,padZero);