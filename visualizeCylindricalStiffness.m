function visualizeCylindricalStiffness(pcl)
    x = pcl.pos_cyl(:, 2);
    y = pcl.val;
    
%     % Binscatter
%     figure(1)
%     title("Binscatter");
%     binscatter(x, y, 50);
%     
%     % Polyfit
%     polyfit_order = 8;
%     figure(2)
%     title(["Polyfit of order ", string(polyfit_order)]);
%     scatter(x, y);
%     hold on;
%     p = polyfit(x, y, polyfit_order);
%     xsorted = sort(x);
%     yp = polyval(p,xsorted);
%     plot(xsorted,yp,'r-')
    
    % Binning data
    nr_bins = 10;
    [bins, edges] = discretize(x, nr_bins);
    half_intervall = 0.5*(edges(2)-edges(1));
    
    means = NaN(nr_bins, 1);
    stds = NaN(nr_bins, 1);
    count = NaN(nr_bins, 1);
    for bin = 1:nr_bins
        x_center(bin) = edges(bin) + half_intervall;
        means(bin) = mean(y(bins == bin));
        stds(bin) = std(y(bins == bin));
        count(bin) = length(y(bins == bin));
    end
    figure(3)
    scatter(x, y, 1, 'filled'); hold on
    plot(x_center, means)
    lo = means - stds;
    hi = means + stds;
    hp = patch([x_center, x_center], [lo', hi'], 'r');
    set(hp, 'facecolor', [1 0.8 0.8], 'edgecolor', 'none');
end

