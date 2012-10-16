function [data] = entln_import(date)
%Imports an ENTLN .CSV lightning file
%Output is YYYY, MM, DD, hh, mm, ss, lat, long, height (m), stroke type,
%amplitude (A), stroke_solution

import=true;

index=1;
dataPath = textread('dataPath.dat','%s\n');
path = '';
pathAlt = '';
for i = 1 : size(dataPath,1);
    if index == 1 && exist(dataPath{i},'dir')
        path = dataPath{i};
        index = index + 1;
    elseif index ==2 && exist(dataPath{i},'dir')
        pathAlt = dataPath{i};
    end
end


en_path = sprintf('%sENfiles/',path);
en_path_alt = sprintf('%sENfiles/',pathAlt);

if strmatch(class(date),'double')
    if length(date)==1;
        date=datevec(date);
        date=date(1:3);
    elseif length(date)~=3
        warning('Unknown Input Format');
    end
    
    fileload=sprintf('%sEN%04g%02g%02g.mat',en_path,date(1:3));
    fileimport=sprintf('%sLtgFlashPortions%04g%02g%02g.csv',en_path,date(1:3));

    fileloadAlt=sprintf('%sEN%04g%02g%02g.mat',ap_path_alt,date(1:3));
    fileimportAlt=sprintf('%sLtgFlashPortions%04g%02g%02g.csv',en_path_alt,date(1:3));
    
    if exist(fileload,'file');
       load(fileload)
       import=false;
    elseif exist(fileloadAlt,'file')
        load(fileloadAlt);
        import=false;
    elseif exist(fileimport,'file');
       fid=fopen(fileimport);
       import=true;
    elseif exist(fileimportAlt,'file');
        fid=fopen(fileloadAlt);
        import=true;
    else
        error('File Not Found!')
    end
    
    
elseif strmatch(class(date),'char')
    fid=fopen(date);
    import=true;
else
    error('Unrecognized filename.')
end

%%

if import
    
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
