function deletevariable(filename,vardel)
%deletevariable loads filename, deletes the variables listed in the cell
%   array vardel and resaves the file under the original name.

%by: Michael Hutchins
%Last update 3/16/2011


load(filename)

vardel=vardel(:);

for i=1:size(vardel,1)
    if i==1
        s=vardel{i};
    else
        s=[s,' ',vardel{i}];
    end
end

eval(sprintf('clear %s',s))

save(filename)
end