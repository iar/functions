function [lma_data,wwlln_data] = chuva_import(date)
%%LMA_IMPORT(date) imports an LMA and WWLLN file from the CHUVA campaign. Date can be given as a
%%date vector [yyyy,mm,dd] or a datenum, or as a filename

%   11/30/11 - Michael Hutchins


if length(date)==1;
    date=datevec(date);
    date=date(1:3);
end

wwlln_path='/Volumes/Data/WWLLNChuva/';

lma_data=lma_import(date);

for i=1:144
    fileDate=datevec(datenum(date)+i/(24*60*60));
    filename=sprintf('%sA%04g%02g%02g%02g%02g.WWLLNchuva.loc',wwlln_path,fileDate(1:5));
    if file_check(filename)
        data=a_import(filename);
        if size(data,1)>0
            if i==1
                wwlln_data=data;
            else
                wwlln_data=[wwlln_data;data];
            end
        end
    end
end


end