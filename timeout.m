function timeout(file,wait,maxtime,type)
%TIMEOUT  Waits until specified file exists
%   Waits until 'file' exists can also specify wait time and max wait time

%   Michael Hutchins - 8/18/11  

switch nargin
    case 1
        wait=10;
        maxtime=60;
        type='file';
    case 2
        maxtime=60;
        type='file';
    case 3
        type='file';
end

time=0;
while ~(exist(file,type)==2) && time<maxtime;
    pause(wait);
    time=time+wait;
end

if time>=maxtime
    fprintf('Warning : Maximum wait time reached, continuing with code.\n');
end
end