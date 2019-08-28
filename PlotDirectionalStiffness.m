% Load Files
vol_0deg = load('MaskedVolume_SWE_C190201_L3L4_0deg_2019_07_31_15_3.mat');
vol_0deg = vol_0deg.masked_vol;
vol_90deg = load('MaskedVolume_SWE_C190201_L3L4_90deg_2019_07_31_15_4.mat');
vol_90deg = vol_90deg.masked_vol;

% Transform into Pointcloud
pcl_0deg = VolumeToPointcloud(vol_0deg);
pcl_90deg = VolumeToPointcloud(vol_90deg);

%% Remove -1 and NaN values
% 0deg
pcl_0deg.pos(isnan(pcl_0deg.val), :) = [];
pcl_0deg.val(isnan(pcl_0deg.val)) = [];
pcl_0deg.pos(pcl_0deg.val == -1, :) = [];
pcl_0deg.val(pcl_0deg.val == -1, :) = [];
% 90deg
pcl_90deg.pos(isnan(pcl_90deg.val), :) = [];
pcl_90deg.val(isnan(pcl_90deg.val)) = [];
pcl_90deg.pos(pcl_90deg.val == -1, :) = [];
pcl_90deg.val(pcl_90deg.val == -1, :) = [];

%% Calculate Centroids
center_0deg = round(CentroidPcl(pcl_0deg));
center_90deg = CentroidPcl(pcl_90deg);

pcl_0deg.pos(:, 1:2) = pcl_0deg.pos(:, 1:2) - center_0deg(1:2); %Keep z coordinate original
pcl_90deg.pos(:, 1:2) = pcl_90deg.pos(:, 1:2) - center_90deg(1:2); %Keep z coordinate original


%% Create cylindrical coordinate system around centroids
% [rho, theta, z]
[pcl_0deg.pos_cyl(:, 2), pcl_0deg.pos_cyl(:, 1)] = cart2pol(pcl_0deg.pos(:, 1),pcl_0deg.pos(:, 2));
pcl_0deg.pos_cyl(:, 3) = pcl_0deg.pos(: , 3);

[pcl_90deg.pos_cyl(:, 2), pcl_90deg.pos_cyl(:, 1)] = cart2pol(pcl_90deg.pos(:, 1),pcl_90deg.pos(:, 2));
pcl_90deg.pos_cyl(:, 3) = pcl_90deg.pos(: , 3);

%% Visualise Results
figure()
subplot(221)
visualizeCylindricalStiffness(pcl_0deg.pos_cyl(:, 2), pcl_0deg.val, 30)
subplot(223)
visualizeCylindricalStiffness(pcl_90deg.pos_cyl(:, 2), pcl_90deg.val, 30)
subplot(222)
polyFit(pcl_0deg.pos_cyl(:, 2), pcl_0deg.val, 8)
subplot(224)
polyFit(pcl_90deg.pos_cyl(:, 2), pcl_90deg.val, 8)