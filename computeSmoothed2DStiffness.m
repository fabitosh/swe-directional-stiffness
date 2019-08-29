function [smoothed_stiffness_array] = computeSmoothed2DStiffness(pcl, conv_filter_size) 
    % Extract values out of the pointcloud
    x = pcl.pos(:, 1);
    y = pcl.pos(:, 2);
    z = pcl.val;
    
    % Find unique x and y coordinates and save their indexes
    [~, ~, xidx] = unique(x);
    [~, ~, yidx] = unique(y);
    % count the number of points at each unique x/y combination
    counts = accumarray([xidx(:), yidx(:)], 1); 
    % Sum of stiffness values that fall into each unique x/y combination 
    % Those are the values of the voxels above or below the measurement
    avgs = accumarray([xidx(:), yidx(:)], z);

    %% Smoothen out the data with a 2D convolution
    filter = ones(conv_filter_size)/(conv_filter_size*conv_filter_size);
    avgs_smoothed = conv2(avgs, filter, 'same');
    counts_smoothed = conv2(counts, filter, 'same');
    smoothed_stiffness_array = avgs_smoothed./counts_smoothed; % Normalization 

    %create a list of the z that fall into each unique x/y combination
    % zs = accumarray([xidx(:), yidx(:)], pcl_0deg.val, [], @(V) {V}, {});
end

