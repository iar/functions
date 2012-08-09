function [data] = entln_import(date)
%Imports an ENTLN .CSV lightning file
%Output is YYYY, MM, DD, hh, mm, ss, lat, long, height (m), stroke type,
%amplitude (A), stroke_solution

Import=false;
en_path='/wd2/ENfiles/';

if strmatch(class(date),'double')
    if length(date)==3
        filenameMat=sprintf('%sEN%04g%02g%02g.mat',en_path,date(1:3));
        if exist(filenameMat,'file')==2,
            load(filenameMat);
            Import=false;
        else
            fid=fopen(sprintf('%sLtgFlashPortions%04g%02g%02g.csv',en_path,date(1:3)));
        end
    elseif length(date)==1;
        date=datevec(date);
        date=date(1:3);
        filenameMat=sprintf('%sEN%04g%02g%02g.mat',en_path,date(1:3));
        if exist(filenameMat,'file')==2,
            load(filenameMat)
            Import=false;
        else
            fid=fopen(sprintf('%sLtgFlashPortions%04g%02g%02g.csv',en_path,date(1:3)));
        end
    else
        warning('Unknown Input Format');
    end
elseif strmatch(class(date),'char')
    fid=fopen(date);
else
    error('Unrecognized filename.')
end

%%

if Import
    
    s=fgets(fid);
    fend=feof(fid);
    index=1;
    data=zeros(20000000,13);

    while(fend==0),
        s=fgets(fid);
%         A = sscanf(s(89:end),'%g-%g-%g %g:%g:%f,%g-%g-%gT%g:%g:%f,%g,%g,%g,%g,%g');
        A = sscanf(s(85:end),'%g/%g/%g %g:%g:%f %2c,%g-%g-%gT%g:%g:%f,%g,%g,%g,%g,%g');
        if isempty(A) || length(A)~=11
            a=strfind(s,',');
            A = sscanf(s(a(3)+1:end),'%g/%g/%g %g:%g:%f %2c,%g-%g-%gT%g:%g:%f,%g,%g,%g,%g,%g');
        end

        B = textscan(s,'%s%s','Delimiter',',,');
        B1 = B{1};
        B2 = B{2};
        B1 = B1{end-1};
        B2 = B2{end-1};
        if length(B1) < length(B2) && length(B1)>=1
            B = B1;
            Balt = B2;
        else
            B = B2;
            Balt = B1;
        end
        B = sscanf(B,'%g');
        if isempty(B)
            B = sscanf(Balt,'%g');
        end
        
        
        D=strfind(s,',,');
        E=strfind(s,'=');
        
        if length(D)>1
            nstn=length(E);
        else
            nstn=length(E)-2;
        end
        
        data(index,:)=[A(9:19)',B,nstn];
        index=index+1;
        fend=feof(fid);
    end

    data=data(1:index-1,:);

    fclose all;

end

%%

end
