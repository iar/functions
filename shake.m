function [out]=shake(in,center,shakes)
   
switch nargin
    case 1
        center=1;
        shakes=1;
    case 2
        shakes=1;
end

for i=1:shakes

    if i>1
        in=out;
    else
    
    in=logical(in);

    end

dimension=ndims(in);

if dimension==1;

        out=circshift(in,1) |...
         circshift(in,-1) |...
         in;
     
elseif dimension==2;
   
    out=circshift(in,[1,0]) |...
         circshift(in,[-1,0]) |...
         circshift(in,[0,1]) |...
         circshift(in,[0,-1]) |...
         in;
   
elseif dimension==3;

    out=circshift(in,[1,0,0]) |...
         circshift(in,[-1,0,0]) |...
         circshift(in,[0,1,0]) |...
         circshift(in,[0,-1,0]) |...
         circshift(in,[0,0,1]) |...
         circshift(in,[0,0,-1]) |...
         in;
end

if center==0
    out=xor(out,in);
end

out=logical(out);

end

end