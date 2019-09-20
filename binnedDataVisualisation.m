function binnedDataVisualisation(x, y, nr_bins, x_label, y_label) 
% Splits x into nr_bins equally sized bins. Computes the mean and standard
% deviation for each bin.
% The plot shows the scatter of all datapoints, the mean curve and the
% confidence interval of one std deviation.
    
    if ~y_label
        y_label = 'Stiffness';
    end

    %% Binning data
    [bins, edges] = discretize(x, nr_bins);
    half_intervall = 0.5*(edges(2)-edges(1));
    
    %% Compute Mean, Std Deviation and amount of points in each bin
    means = NaN(1, nr_bins);
    stds = NaN(1, nr_bins);
    count = NaN(1, nr_bins);
    for bin = 1:nr_bins
        x_center(bin) = edges(bin) + half_intervall;
        means(bin) = mean(y(bins == bin));
        stds(bin) = std(y(bins == bin));
        count(bin) = length(y(bins == bin));
    end
    
    %% Visualise Results
    scatter(x, y, 1, 'filled'); hold on
    yyaxis left
    ylabel(y_label)
    xlabel(x_label)
    plot(x_center, means, "-k", 'LineWidth', 1)
    low = means - stds;
    high = means + stds;
    xx = [x_center fliplr(x_center)];
    yy = [low fliplr(high)];
    fill(xx, yy, 'k', 'EdgeColor', 'none', 'FaceAlpha', 0.25);
    yyaxis right
    ylabel('Elements per Bin')
    plot(x_center, count, '--', 'color', [0.8500, 0.3250, 0.0980], 'LineWidth', 0.75);
end

