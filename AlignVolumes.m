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
% pcl_0deg.pos(pcl_0deg.val == -1, :) = [];
% pcl_0deg.val(pcl_0deg.val == -1, :) = [];
% 90deg
pcl_90deg.pos(isnan(pcl_90deg.val), :) = [];
pcl_90deg.val(isnan(pcl_90deg.val)) = [];
% pcl_90deg.pos(pcl_90deg.val == -1, :) = [];
% pcl_90deg.val(pcl_90deg.val == -1, :) = [];

%% Rotation
R1 = [1, 0, 0; 0, 1, 0; 0, 0, 1];   % no rotation
R2 = [0, -1, 0; 1, 0, 0; 0, 0, 1];  % +90deg around z
R3 = [0, 1, 0; -1, 0, 0;, 0, 0, 1]; % -90deg around z
pcl_90deg.pos = (R2 * pcl_90deg.pos.')';

%% Calculate Centroids and their difference
center_0deg = CentroidPcl(pcl_0deg);
center_90deg = CentroidPcl(pcl_90deg);
tf = center_90deg - center_0deg;

%% Translation
pcl_90deg.pos = pcl_90deg.pos - tf;

%% Visualize the wobababu
figure(1)
subplot(221)
title("xz")
scatter(pcl_0deg.pos(:, 1), pcl_0deg.pos(:, 3),'.'); hold on;
scatter(pcl_90deg.pos(:, 1), pcl_90deg.pos(:, 3),'.'); hold off;
axis equal;
subplot(222)
title("yz")
scatter(pcl_0deg.pos(:, 2), pcl_0deg.pos(:, 3),'.'); hold on;
scatter(pcl_90deg.pos(:, 2), pcl_90deg.pos(:, 3),'.'); hold off;
axis equal;
subplot(223)
title("xy")
scatter(pcl_0deg.pos(:, 1), pcl_0deg.pos(:, 2),'.'); hold on;
scatter(pcl_90deg.pos(:, 1), pcl_90deg.pos(:, 2),'.'); hold off;
axis equal;
subplot(224)
scatter3(pcl_0deg.pos(:, 1), pcl_0deg.pos(:, 2), pcl_0deg.pos(:, 3),'.'); hold on;
scatter3(pcl_90deg.pos(:, 1), pcl_90deg.pos(:, 2), pcl_90deg.pos(:, 3),'.'); hold off;
axis equal;