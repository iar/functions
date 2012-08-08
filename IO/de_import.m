function [de_map,de_map_high,de_time] = de_import(date)
%Imports an altered A file that includes power information for each station

de_path='/Volumes/Time Machine/Data/deMaps/';

if strmatch(class(date),'double')
    if length(date)==3
        filename=sprintf('%sDE%04g%02g%02g',de_path,date(1:3));
    elseif length(date)==1;
        date=datevec(date);
        date=date(1:3);
        filename=sprintf('%sDE%04g%02g%02g',de_path,date(1:3));
    else
        warning('Unknown Input Format');
    end
elseif strmatch(class(date),'char')
    filename=date;
else
    error('Unrecognized filename.')
end

load(filename);

end
