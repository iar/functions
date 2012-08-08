function [local_time]=utc2loc(time,longitude)
    time=time(:);
    A=time+longitude./15;
    B=zeros(size(time,1),1);
    for i=1:size(time,1)
        if A(i)>23
            B(i)=A(i)-24;
        elseif A(i)<0
            B(i)=A(i)+24;
        else
            B(i)=A(i);
        end
    end
    local_time=B;
end