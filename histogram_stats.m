function [ histStats ] = histogram_stats(histogram, base)
% HISTOGRAM_STATS returns the mean, median, standard deviation, and median
%   absolute deviation for an input histogram given the base vector.

    vector = zeros(sum(histogram),1);
    index = 1;
    for i = 1 : length(base)
        
        nextIndex = index+histogram(i);
        
        vector(index : nextIndex - 1) = repmat(base(i),histogram(i),1);
        
        index = nextIndex;
    end

    histMean   = mean(vector);
    histMedian = median(vector);
    histStd    = std(vector);
    histMad    = mad(vector);
    histPop25  = prctile(vector,25);
    histPop75  = prctile(vector,75);
    
    histStats = [histMean, histMedian, histStd, histMad,...
                 histPop25, histPop75];

end

