function [data_power]=recalculate_power(data,power)
%This function recalculates the power based on previous coversion rates and
%the Bootstrap_v3 method as of 5/4/11

[station_loc]=station_import('stations.dat'); %WWLLN station info

scottbase_conversion=3*10^6; %Obtained from James Brundell, personal communication
station_conversion=scottbase_conversion/sqrt(0.63);%Correct to be Dunedin converison


file='/Volumes/Time Machine/Data/APP_files/Bootstrap_conversions.txt';
file='Bootstrap_conversions.txt';

fid=fopen(file);

conversion=fscanf(fid,'%g ',[67 Inf]);

conversion=conversion';

date=data(1,1:3);

conversion=conversion(conversion(:,1)==datenum(date),2:end);

%Initialization and parameters

%Load the lookup data
lookup_day=lookup_import('lookup_day.dat');
lookup_night=lookup_import('lookup_night.dat');
lookup_dist=lookup_import('lookup_dist.dat');
div=360/size(lookup_day,1);


%Initialization
boot=zeros(size(data,1),size(station_loc,1));
boot_dist=boot;

%Calculate local power for each station in stroke i
for i=1:size(data,1);
    j=1;
    while power(i,j)~=0 || (power(i,1)==0 && j==1);
        b=ceil((data(i,7)+90)/div);
        a=ceil((data(i,8)+180)/div);
        if a<=0
            a=1;
        elseif a>360/div
            a=floor(360/div);
        end
        if b<=0
            b=1;
        elseif b>180/div
            b=floor(180/div);
        end                       

        % % Adding in day/night consideration
        stat_loc=station_loc(power(i,j)+1,:);

        stroke_power_day=lookup_day(a,b,power(i,j)+1);
        stroke_power_night=lookup_night(a,b,power(i,j)+1);
        if abs(data(i,8))<=180
            [day,night]=terminator(data(i,7),data(i,8),data(i,1:6),stat_loc(1),stat_loc(2));
        elseif abs(data(i,8))>180
            [day,night]=terminator(data(i,7),wrapTo180(data(i,8)),data(i,1:6),stat_loc(1),stat_loc(2));
        end
        stroke_power=day*stroke_power_day+night*stroke_power_night;

        boot(i,j)=power(i,j);
        boot(i,j+1)=power(i,j+1)^2*100000/(station_conversion^2*10^(stroke_power/10)*(10^-6)^2)/conversion(power(i,j)+1);

        boot_dist(i,j+1)=lookup_dist(a,b,power(i,j)+1);
        if stroke_power<=0 || boot_dist(i,j+1) > 8000
            boot_dist(i,j+1)=0;
            boot(i,j+1)=0;
        end
        j=j+2;
    end
end    

%Calculate power
for i=1:size(boot,1);
    %Extract power information
    power_all=boot(i,2:2:end);
    power_all(power_all==0 | isinf(power_all) | isnan(power_all))=[];
    energy(i,:)=median(power_all);
    energy_error(i,:)=mmad(power_all);
    nstn(i,:)=sum(power_all>0);
end
data_power=[data,energy./1000,energy_error./1000,nstn];
end

