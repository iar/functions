function [ LShell ] = lshell(lat,long)
%LSHELL returns the magnetic l-shell value for the given LAT and LONG.
%
%   Written By:  Michael Hutchins

rEarth=6371;
NOW=now;
lat=lat(:);
long=wrapTo180(long(:));

if length(lat)~=length(long)
    if length(lat)==1
        lat=repmat(lat,length(long),1);
    elseif length(long)==1
        long=repmat(long,length(lat),1);
    else
        error('Input size error');
    end
end

lat=lat(:);
long=long(:);
tic;

for i=1:length(lat);
    LATITUDE=lat(i);
    LONGITUDE=long(i);
    ALTITUDE=0; %km above surface
    DIST=10000;
    STEPS=100;
    [LAT,LONG,alt]=igrfline(NOW,LATITUDE,LONGITUDE,ALTITUDE,'geodetic',DIST,STEPS);
    
    altLoc=locTest(alt);            

    if sum(alt(altLoc)>0)<2;
        DIST=-DIST;
        [LAT,LONG,alt]=igrfline(NOW,LATITUDE,LONGITUDE,ALTITUDE,'geodetic',DIST,STEPS);
    end
    
    altLoc=locTest(alt);            

    if sum(alt(altLoc)>0)<2;
        DIST=-DIST/10;
        STEPS=STEPS*10;
        [LAT,LONG,alt]=igrfline(NOW,LATITUDE,LONGITUDE,ALTITUDE,'geodetic',DIST,STEPS);
    end
    
    altLoc=locTest(alt);            

    if sum(alt(altLoc)>0)<2;
        DIST=-DIST;
        STEPS=STEPS;
        [LAT,LONG,alt]=igrfline(NOW,LATITUDE,LONGITUDE,ALTITUDE,'geodetic',DIST,STEPS);
    end

    altLoc=locTest(alt);            
    alt=alt(altLoc);
    LAT=LAT(altLoc);
    LONG=LONG(altLoc);

    if ~isempty(alt) && ( alt(1)==max(alt) || alt(end)==max(alt) )
        DIST=DIST*10;
        STEPS=STEPS;
        [LAT,LONG,alt]=igrfline(NOW,LATITUDE,LONGITUDE,ALTITUDE,'geodetic',DIST,STEPS);
    end

    altLoc=locTest(alt);
    alt=alt(altLoc);
    LAT=LAT(altLoc);
    LONG=LONG(altLoc);            

    if ~isempty(alt) && ( alt(1)==max(alt) || alt(end)==max(alt) )
        DIST=DIST*10;
        STEPS=STEPS;
        [LAT,LONG,alt]=igrfline(NOW,LATITUDE,LONGITUDE,ALTITUDE,'geodetic',DIST,STEPS);
    end

    altLoc=locTest(alt);
    alt=alt(altLoc);
    LAT=LAT(altLoc);
    LONG=LONG(altLoc);   

    LAT=LAT(alt>0);
    LONG=wrapTo180(LONG(alt>0));
    alt=alt(alt>0);

    if rem(i,2500)==0;    
        fprintf('%g finished: %.02g seconds\n',i,toc);
    end
    
    if isempty(alt)
        LShell(i)=1;
    else
        LShell(i)=(alt(alt==max(alt))./rEarth)+1;
    end
end

LShell=LShell(:);

end

