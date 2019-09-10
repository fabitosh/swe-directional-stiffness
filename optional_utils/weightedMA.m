function [filtered_data] = weightedMA(inputdata, weights, filterwidth)
% Filtering inputdata with a moving average of size filterwidth.
% The filter components are weighted according to the corresponding values
% in the weight vector. 
    filterwidth = OddInteger(filterwidth);
    cutoff = int8(fix((filterwidth-1)/2));
    filtered_data = NaN(1, length(inputdata));
    stop = length(inputdata)-cutoff;
    for ii = (cutoff+1):stop
        idxleft = ii-cutoff;
        idxright = ii+cutoff;
        w = weights(idxleft:idxright)./sum(weights(idxleft:idxright));
        filtered_data(ii) = inputdata(idxleft:idxright) * w';
    end
    subplot(211);
    title('Signal')
    plot(inputdata); hold on;
    plot(filtered_data);
    subplot(212);
    title('Weights')
    plot(weights);
end

function y = OddInteger(x)
    y = 2*floor(x/2)+1;
end