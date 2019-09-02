function [outputArg1,outputArg2] = uberplotMaskedVolPair(vol_0deg_mask, vol_90deg_mask)
    %% Transform into Pointcloud
    pcl_0deg_masked = volumeToPointcloud(vol_0deg_mask);
    pcl_90deg_masked = volumeToPointcloud(vol_90deg_mask);
    
    %% Remove NaN values
    % 0deg
    pcl_0deg_masked.pos(isnan(pcl_0deg_masked.val), :) = [];
    pcl_0deg_masked.val(isnan(pcl_0deg_masked.val)) = [];
    % 90deg
    pcl_90deg_masked.pos(isnan(pcl_90deg_masked.val), :) = [];
    pcl_90deg_masked.val(isnan(pcl_90deg_masked.val)) = [];
          
    %% Calculate Centroids and shift x-y coordinates
    center_0deg = round(centroidPcl(pcl_0deg_masked));
    center_90deg = round(centroidPcl(pcl_90deg_masked));
    pcl_0deg_masked.pos(:, 1:2) = pcl_0deg_masked.pos(:, 1:2) - center_0deg(1:2);  % Keep z coordinate original
    pcl_90deg_masked.pos(:, 1:2) = pcl_90deg_masked.pos(:, 1:2) - center_90deg(1:2);  % Keep z coordinate original
    
    % Duplicate pcl
    pcl_0deg = pcl_0deg_masked;
    pcl_90deg = pcl_90deg_masked;
    min_pos_0deg_mask = min(pcl_0deg.pos);
    max_pos_0deg_mask = max(pcl_0deg.pos);
    min_pos_90deg_mask = min(pcl_90deg.pos);
    max_pos_90deg_mask = max(pcl_90deg.pos);
    
    % Delete Mask points in the stiffness pcl
    pcl_0deg.pos(pcl_0deg.val == -1, :) = [];
    pcl_0deg.val(pcl_0deg.val == -1, :) = [];
    pcl_90deg.pos(pcl_90deg.val == -1, :) = [];
    pcl_90deg.val(pcl_90deg.val == -1, :) = [];
    min_pos_0deg = min(pcl_0deg.pos);
    min_pos_90deg = min(pcl_90deg.pos);
    max_pos_0deg = max(pcl_0deg.pos);
    max_pos_90deg = max(pcl_90deg.pos);
    
    %Calculate the shift done by the deletion of the mask points
    shift_0deg = min_pos_0deg - min_pos_0deg_mask    
    shift_90deg = min_pos_90deg - min_pos_90deg_mask
    cutoff_0deg = max_pos_0deg_mask - max_pos_0deg
    cutoff_90deg = max_pos_90deg_mask - max_pos_90deg
    
    %% Create cylindrical coordinate system coordinates around centroids
    % pcl_0deg.pos_cyl is set up in [rho, theta, z]
    [pcl_0deg.pos_cyl(:, 2), pcl_0deg.pos_cyl(:, 1)] = cart2pol(pcl_0deg.pos(:, 1),pcl_0deg.pos(:, 2));
    pcl_0deg.pos_cyl(:, 3) = pcl_0deg.pos(: , 3);

    [pcl_90deg.pos_cyl(:, 2), pcl_90deg.pos_cyl(:, 1)] = cart2pol(pcl_90deg.pos(:, 1),pcl_90deg.pos(:, 2));
    pcl_90deg.pos_cyl(:, 3) = pcl_90deg.pos(: , 3);

    %% 3D Visualizations
    % Those work with the carthesian coordinate system
%     plot2DStiffness(computeSmoothed2DStiffness(pcl_0deg, 1.5)); % Only look at one scan
    %compareStiffnessSurf(pcl_0deg, pcl_90deg, 1.5); % Compare 0 and 90 degree scans

    %% UEBERPLOT
    figure('visible','off')
    set(gcf,'position',[10,100,1600,800])
%     subplot(241)
%     binnedDataVisualisation(pcl_0deg.pos_cyl(:, 1), pcl_0deg.val, 30, 'Radius - 0deg Scan');
%     subplot(245)
%     binnedDataVisualisation(pcl_90deg.pos_cyl(:, 1), pcl_90deg.val, 30, 'Radius - 90deg Scan');
%     subplot(242)
%     binnedDataVisualisation(pcl_0deg.pos_cyl(:, 2), pcl_0deg.val, 30, 'Angle - 0deg Scan');
%     subplot(246)
%     binnedDataVisualisation(pcl_90deg.pos_cyl(:, 2), pcl_90deg.val, 30, 'Angle - 90deg Scan');
%     subplot(243)
%     binnedDataVisualisation(pcl_0deg.pos_cyl(:, 3), pcl_0deg.val, 30, 'Height z - 0deg Scan');
%     subplot(247)
%     binnedDataVisualisation(pcl_90deg.pos_cyl(:, 3), pcl_90deg.val, 30, 'Height - 90deg Scan');   
%     subplot(244)
%     plotMaskAndStiffness(pcl_0deg_masked, pcl_0deg)
%     subplot(248)
%     plotMaskAndStiffness(pcl_90deg_masked, pcl_90deg)

    subplot(121)
    plotMaskAndStiffness(pcl_0deg_masked, pcl_0deg, shift_0deg, cutoff_0deg)
    subplot(122)
    plotMaskAndStiffness(pcl_90deg_masked, pcl_90deg, shift_90deg, cutoff_90deg)
end

function plotMaskAndStiffness(pcl_masked, pcl, shift, cutoff)
%     colormap([1 0 0;0 0 1])
    mask_array = compMaskArray(pcl_masked);
    disp(size(mask_array))
    surf(mask_array, 'EdgeColor', 'none', 'FaceAlpha', 0.5); hold on;
    stiffness_array = compSmoothed2DStiffnessArray(pcl, 2);
    disp(size(stiffness_array))
    shift_y = shift(1);
    shift_x = shift(2);
    cutoff_y = cutoff(1);
    cutoff_x = cutoff(2);
    [y_stiff, x_stiff] = size(stiffness_array); 
    stiffness_array_shifted = ...
        [NaN(shift_y, shift_x + x_stiff + offset_x); ...
         NaN(y_stiff, shift_x), stiffness_array, NaN(y_stiff, cutoff_x);
         NaN(cutoff_y, shift_x + x_stiff + offset_x)];
                               
    disp(size(stiffness_array_shifted))
    surf(stiffness_array_shifted, 'EdgeColor', 'none', 'FaceAlpha', 1);
    colorbar
    caxis([0 16])
    axis equal
    view(0,90)
end

