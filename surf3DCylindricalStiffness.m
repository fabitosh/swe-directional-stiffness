function surf3DCylindricalStiffness(x, y, nr_bins) 
    % Binning data
    [bins, edges] = discretize(x, nr_bins);
    half_intervall = 0.5*(edges(2)-edges(1));
    
    hist3(pcl_0deg.pos(:, 1:2))
end

