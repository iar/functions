function result=locTest(input)
%
%   Written By:  Michael Hutchins

    altTest=input>0;
    altLoc=false(size(altTest));
    for n=1:length(altTest);
        if n==1
            altLoc(n)=altTest(n);
        elseif sum(altLoc)==0
            altLoc(n)=altTest(n);
        elseif altTest(n-1)==true && altTest(n)==true && altLoc(n-1)==true
            altLoc(n)=true;
        else
            altLoc(n)=false;
        end
    end
    result=altLoc;
end