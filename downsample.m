function [ Y ] = downsample( X , factor )
%downsample takes an array of data (such as hist results) and downsamples
%   the resolution by factor. So a 100 x 1 with a factor of 2 becomes a 
%   50 x 1 array. Works up to 2-D arrays.
%   Note: Uneven ends are padded with zeros so they may need to be scaled
%
%   Written By:  Michael Hutchins

    if mod(size(X,1),factor) ~= 0
        paddingX = factor - mod(size(X,1),factor);
        X = [X ; zeros(paddingX,size(X,2))];
    else
        paddingX = 0;
    end

    if mod(size(X,2),factor) ~= 0
        paddingY = factor - mod(size(X,2),factor);
        X = [X , zeros(size(X,1),paddingY)];
    else
        paddingY = 0;
    end
    
%     if sum(size(X) == 1) == 1
%         
%         X = X(:);
%         Y = zeros(length(X) / factor , 1);
%     
%         for i = 1 : factor
%             Y = Y + X(i:factor:end);
%         end
%         
%     else
%         
    Y = zeros(size(X,1) / factor, size(X,2) / factor);

    for i = 1 : factor
        for j = 1 : factor
            Y = Y + X(i:factor:end,j:factor:end,:);
        end
    end

%     end
%     
%     if paddingY ~=0
%         Y(:,end) = Y(:,end) .* ((factor) / (factor - paddingY));
%     end
%     
%     if paddingX ~=0
%         Y(end,:) = Y(end,:) .* ((factor) / (factor - paddingX));
%     end

end

