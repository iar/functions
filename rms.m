function [ RMS ] = rms( vector )
%Gives the Root-Mean-Square value

RMS=sqrt(mean(vector.^2));

end

