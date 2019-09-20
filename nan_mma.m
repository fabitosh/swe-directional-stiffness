function [x_smoothed] = nan_mma(x, filter_width)
% Adapted Mean Moving Average built to handle and disregard NaN's 
% A NaN in the signal x is overwritten by the mean of the surrounding values
% NaN's have no weight on the mean average. The normalisation is adaptive.

    % Filter width has to be uneven
    if mod(filter_width,2) == 0
        filter_width = filter_width +1;
    end
    overlap = (filter_width-1)/2;
    
    % Input Signal is periodic. Extend x to accordingly set boundaries
    x_extend = [x((length(x)-overlap+1):end); x; x(1:overlap)];
    x_smoothed = NaN(size(x));
    
    % Loop over all signal points
    for ii_signal = 1:length(x)
        normalisation = 0;
        % Compute the Average over the filter_width for said point
        % We add the values individually and normalize at the end
        for ii_filter = -overlap:overlap
            temp_summand = x_extend(ii_signal+overlap-ii_filter);
            % NaN + value = NaN, this makes it = value
            if ~isnan(temp_summand)
                if isnan(x_smoothed(ii_signal))
                    x_smoothed(ii_signal) = temp_summand;
                else
                    x_smoothed(ii_signal) = x_smoothed(ii_signal) + temp_summand;
                end
                normalisation = normalisation +1;                
            end
        end
        x_smoothed(ii_signal) = x_smoothed(ii_signal) / normalisation;
    end
    
    % Align first and last value
    x_overlap = 0.5 * (x_smoothed(1) + x_smoothed(end));
    x_smoothed(1) = x_overlap;
    x_smoothed(end) = x_overlap;
end