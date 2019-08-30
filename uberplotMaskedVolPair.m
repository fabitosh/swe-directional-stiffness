function [outputArg1,outputArg2] = uberplotMaskedVolPair(vol_0deg_mask, vol_90deg_mask)
    %% Transform into Pointcloud
    pcl_0deg_masked = volumeToPointcloud(vol_0deg_mask);
    pcl_90deg_masked = volumeToPointcloud(vol_90deg_mask);

    %% Remove -1 and NaN values
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
    
    pcl_0deg = pcl_0deg_masked;
    pcl_90deg = pcl_90deg_masked;
%     pcl_0deg.pos(pcl_0deg.val == -1, :) = [];
    pcl_0deg.val(pcl_0deg.val == -1, :) = 0; %[];
%     pcl_90deg.pos(pcl_90deg.val == -1, :) = [];
    pcl_90deg.val(pcl_90deg.val == -1, :) = 0; %[];

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
    figure('visible','on')
    set(gcf,'position',[10,100,1600,800])
    subplot(241)
    binnedDataVisualisation(pcl_0deg.pos_cyl(:, 1), pcl_0deg.val, 30, 'Radius - 0deg Scan');
    subplot(245)
    binnedDataVisualisation(pcl_90deg.pos_cyl(:, 1), pcl_90deg.val, 30, 'Radius - 90deg Scan');
    subplot(242)
    binnedDataVisualisation(pcl_0deg.pos_cyl(:, 2), pcl_0deg.val, 30, 'Angle - 0deg Scan');
    subplot(246)
    binnedDataVisualisation(pcl_90deg.pos_cyl(:, 2), pcl_90deg.val, 30, 'Angle - 90deg Scan');
    subplot(243)
    binnedDataVisualisation(pcl_0deg.pos_cyl(:, 3), pcl_0deg.val, 30, 'Height z - 0deg Scan');
    subplot(247)
    binnedDataVisualisation(pcl_90deg.pos_cyl(:, 3), pcl_90deg.val, 30, 'Height - 90deg Scan');
    
    subplot(244)
    surf(computeMaskArray(pcl_0deg_masked), 'FaceColor', 'k'); hold on;
    s = surf(computeSmoothed2DStiffness(pcl_0deg, 2));
    s.EdgeColor = 'none';
    colorbar
    caxis([-1 16])
    axis equal
    view(0,90)
    
    subplot(248)
    surf(computeMaskArray(pcl_90deg_masked), 'FaceColor', 'k'); hold on;
    s = surf(computeSmoothed2DStiffness(pcl_90deg_masked, 2));
    s.EdgeColor = 'none';
    colorbar
    caxis([-1 16])
    axis equal
    view(0,90)
end

