function [Data]=Import(Year,Month,Day,Length,region,lat,long,local)
%
%   Written By:  Michael Hutchins

switch nargin
    case 3
        Length=1;
        region=0;
        lat=[];
        long=[];
        local=1;
    case 4
        region=0;
        lat=[];
        long=[];
        local=1;
    case 5
        error('Specify latitude and longitude')
    case 6
        error('Specifiy longitude')
    case 7
        local=1;
end
    

if size(lat,1)>1
        Data=zeros(Length,1+size(lat,1));
end

for i=1:Length
    long_date=datevec(datenum([Year,Month,Day])-i+1);
    year=long_date(1);
    month=long_date(2);
    day=long_date(3);

%     system(sprintf('rm A%04g%02g%02g.loc',year,month,day));
    
    if local==0

        [result,msg]=system(sprintf('scp mlhutch@flash3.ess.washington.edu:/flashweb/wfdatax/www/html/ieee_nsa/A%04g%02g%02g.loc .',year,month,day));
        if result==1
            [result2,msg]=system(sprintf('scp mlhutch@flash3.ess.washington.edu:/flashweb/wfdatax/www/html/ieee_nsa/A%04g%02g/A%04g%02g%02g.loc .',year,month,year,month,day));
            if result2==1
                [result3,msg]=system(sprintf('scp mlhutch@flash3.ess.washington.edu:/flashdat/wwlnd1/Afiles/A%04gdaily/A%04g%02g%02g.loc .',year,year,month,day));
                if result3==1
                    error('File not found')
                end
            end
        end
    
        filename=sprintf('A%4g%02g%02g.loc',year,month,day); 
    else
%         filename=sprintf('A%4g%02g%02g.loc',year,month,day); 
% %         cd /Volumes/Data/WWLLN/A_file/

    if exist('/Volumes/Data/','dir')==7
        filename=sprintf('../../../../../../Volumes/Data/WWLLN/A_files/A%4g%02g%02g.loc',year,month,day); 
    else
        error('Data Hard Drive Not Attached')
    end
    end
    
fid=fopen(filename);
% s=fgets(fid);
% fend=feof(fid);
% index=1;
% data=zeros(1000000,10);

% while(fend==0),
%     fend=feof(fid);
%     [A, count, errmsg, nextindex] = sscanf(s,'%d/%d/%d,%d:%d:%f,%f,%f,%f,%d');
    A = fscanf(fid,'%d/%d/%d,%d:%d:%f,%f,%f,%f,%d',[10 Inf]);

%     data(index,:)=A;
%     index=index+1;
% %     s=fgets(fid);
% end

data=A';
% data=data(1:index-1,:);

if size(lat,1)==1 || isempty(lat)
    if region==1;
        loc_tot= data(:,7)<lat(1,2) &...
                    lat(1,1)<data(:,7) &...
                    data(:,8)<long(1,2) &...
                    long(1,1)<data(:,8);  

             data_loc=data(loc_tot,:);
    else
        data_loc=data;
    end

    if i==1
        Data=data_loc;
    else
        Data=[Data;data_loc];
    end
else
    for j=1:size(lat,1)
        if region==1;
            loc_tot= data(:,7)<lat(j,2) &...
                    lat(j,1)<data(:,7) &...
                    data(:,8)<long(j,2) &...
                    long(j,1)<data(:,8);  
             
            loc_tot=sum(loc_tot);
                
        else
            loc_tot=size(data,1);
        end
        Data(i,j+1)=loc_tot;
        Data(i,1)=datenum(data(1,1:3));
    end
end

fclose all;

if local==0
system(sprintf('rm A%04g%02g%02g.loc',year,month,day));
end


end