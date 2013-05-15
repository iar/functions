function [ chosen ] = random_from_vector( vector, number, seed )
%random_from_vector picks NUMBER of items from the VECTOR
%   The seed can be set to ensure the same random selection is chosen
%   random_from_vector(vector) will choose a single random element
%   random_from_vector(vector, N), will choose N random elements
%   random_from_vector(vector,N,SEED), will choose N with the seed SEED.

    switch nargin
        case 1
            number = 1;
        case 3
            s = RandStream('mrg32k3a','Seed',seed);
            % setDefaultStream is used instead of setGlobalStream since this needs
            % to run on r2009a on the servers.
            warning off
            RandStream.setDefaultStream(s);
            warning on
    end
              
    chosen = zeros(number,1);
    for i = 1 : number
        choose = 1 + floor(rand() * length(vector));
        chosen(i) = vector(choose);
    end
    
end

