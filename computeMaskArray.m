function [mask_array] = computeMaskArray(pcl)
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

    %% Smoothen out the data with a 2D convolution
%     conv_filter_size = 5;
%     filter = ones(conv_filter_size)/(conv_filter_size*conv_filter_size);
    filter = [1, 1, 2, 1, 1;
              1, 2, 4, 2, 1; 
              2, 4, 8, 2, 1;
              1, 2, 4, 2, 1;
              1, 1, 2, 1, 1];
    filter = 1/sum(filter, 'all').* filter; 
    mask_array = conv2(counts, filter, 'same');
    mask_array = (mask_array > 0).*-1;
end

