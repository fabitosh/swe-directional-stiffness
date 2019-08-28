function visualizeCylindricalStiffness(x, y, nr_bins) 
    % Binning data
    [bins, edges] = discretize(x, nr_bins);
    half_intervall = 0.5*(edges(2)-edges(1));
    
    means = NaN(1, nr_bins);
    stds = NaN(1, nr_bins);
    count = NaN(1, nr_bins);
    for bin = 1:nr_bins
        x_center(bin) = edges(bin) + half_intervall;
        means(bin) = mean(y(bins == bin));
        stds(bin) = std(y(bins == bin));
        count(bin) = length(y(bins == bin));
    end
    
    scatter(x, y, 1, 'filled'); hold on
    plot(x_center, means)
    low = means - stds;
    high = means + stds;
    xx = [x_center fliplr(x_center)];
    yy = [low fliplr(high)];
    fill(xx, yy, 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.2)
end

