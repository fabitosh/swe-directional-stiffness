function [smoothed_stiffness_array_filtered] = compSmoothed2DStiffnessArray(pcl, count_threshold) 
% Takes a pointcloud pcl, flattens it to the xy-plane (averaging over all z
% values).
% Smoothens the output with a 2d gaussian mask of size 5 in both directions.
% count_threshold sets a limit for the amount of points which are needed
% for the stiffness to be estimated
% Returns the flattened and stiffened array without retained absolute 
% position values.

    %% Extract values out of the pointcloud
    x = pcl.pos(:, 1);
    y = pcl.pos(:, 2);
    z = pcl.val;
    
    %% Find unique x and y coordinates and save their indexes
    [~, ~, xidx] = unique(x);
    [~, ~, yidx] = unique(y);
    % count the number of points at each unique x/y combination
    counts = accumarray([xidx(:), yidx(:)], 1); 
    % Sum of stiffness values that fall into each unique x/y combination 
    % Those are the values of the voxels above or below the measurement
    sums = accumarray([xidx(:), yidx(:)], z);

    %% Smoothen out the data with a 2D convolution
    % A) Mean Mask:
    %conv_filter_size = 3;
    %filter = ones(conv_filter_size)/(conv_filter_size*conv_filter_size);
    % B) Gaussian Mask
    filter = [1, 1, 2, 1, 1;
              1, 2, 4, 2, 1; 
              2, 4, 8, 2, 1;
              1, 2, 4, 2, 1;
              1, 1, 2, 1, 1];
    filter = 1/sum(filter, 'all').* filter; 
    sums_smoothed = conv2(sums, filter, 'same');
    counts_smoothed = conv2(counts, filter, 'same');
    smoothed_stiffness_array = sums_smoothed./counts_smoothed; % Normalization 
    smoothed_stiffness_array_filtered = (counts_smoothed > count_threshold).* smoothed_stiffness_array;

    % If subsampling is desired, uncomment the following line:
    %smoothed_stiffness_array = smoothed_stiffness_array(1:conv_filter_size:end,1:conv_filter_size:end);

    % Create a list of the z that fall into each unique x/y combination
    %zs = accumarray([xidx(:), yidx(:)], z, [], @(V) {V}, {});
end

