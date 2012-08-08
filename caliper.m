function [a,b]=caliper(X,Y,varargin)
%caliper.m uses a caliper method to determine the size of a set of points
%   given by X, Y
%   Options:
%       'Degree' - Input (X,Y) in (long,lat) and output in kilometers
%       'stepSize',degrees - Rotational step size in degrees
%       'Median' - Determines center as the median of the points
%       'Mean' - Determines center as the mean of the points
%       'rms' - Determines the center as the root-mean-square of the points

%   10/12/2011 - Michael Hutchins

%   Future improvements - make accurate over spherical geometry

Options=varargin;
stepSize=5;
centering='mean';
Degree=false;
for i=1:length(Options)
    if strncmp(Options{i},'stepSize',3)
        stepSize=Options{i+1};
    elseif strncmp(Options{i},'Median',6)
        centering='median';
    elseif strncmp(Options{i},'Mean',4)
        centering='mean';
    elseif strncmp(Options{i},'RMS',3)
        centering='rms';
    elseif strncmp(Options{i},'Degree',6)
        Degree=true;
    end
end

if length(X)<=1
    error('Not Enough Data')
end

if Degree && max(abs(Y))>90
    error('Lat/long switched')
end
    


eval(sprintf('center=[%s(X),%s(Y)];',centering,centering));

x=X-center(1);
y=Y-center(2);

h=zeros(180/stepSize,1);
w=h;

for i=1:180/stepSize;
    theta=i*stepSize;
    R=[cosd(theta) -sind(theta); sind(theta) cosd(theta)];
    rot=R*[x,y]';
    xRot=rot(1,:);
    yRot=rot(2,:);
    
    if Degree
        h(i)=vdist(max(yRot)+center(2),center(1),min(yRot)+center(2),center(1))/1000;
        w(i)=vdist(center(2),max(xRot)+center(1),center(2),min(xRot)+center(1))/1000;
    else
        h(i)=max(yRot)-min(yRot);
        w(i)=max(xRot)-min(xRot);
    end
end
    
minAngle=find(h.*w==min(h.*w));
minDim=[w(minAngle),h(minAngle)];

a=minDim(minDim(:,1)==max(minDim(:,1)),1);
b=minDim(minDim(:,1)==max(minDim(:,1)),2);
    
end