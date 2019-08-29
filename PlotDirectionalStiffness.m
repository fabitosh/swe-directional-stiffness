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

%% Calculate Centroids and shift y-z coordinates
center_0deg = round(CentroidPcl(pcl_0deg));
center_90deg = round(CentroidPcl(pcl_90deg));
pcl_0deg.pos(:, 1:2) = pcl_0deg.pos(:, 1:2) - center_0deg(1:2);  % Keep z coordinate original
pcl_90deg.pos(:, 1:2) = pcl_90deg.pos(:, 1:2) - center_90deg(1:2);  % Keep z coordinate original

%% Create cylindrical coordinate system around centroids
% [rho, theta, z]
[pcl_0deg.pos_cyl(:, 2), pcl_0deg.pos_cyl(:, 1)] = cart2pol(pcl_0deg.pos(:, 1),pcl_0deg.pos(:, 2));
pcl_0deg.pos_cyl(:, 3) = pcl_0deg.pos(: , 3);

[pcl_90deg.pos_cyl(:, 2), pcl_90deg.pos_cyl(:, 1)] = cart2pol(pcl_90deg.pos(:, 1),pcl_90deg.pos(:, 2));
pcl_90deg.pos_cyl(:, 3) = pcl_90deg.pos(: , 3);

%% Visualise Results
% 2D Plots
% .pos_cyl(:, 1) are rho values, .pos_cyl(:, 2) are theta values
xleft = pcl_0deg.pos_cyl(:, 1);
xright = pcl_90deg.pos_cyl(:, 1);

figure(1)
subplot(221)
visualizeCylindricalStiffness(xleft, pcl_0deg.val, 30)
subplot(223)
visualizeCylindricalStiffness(xright, pcl_90deg.val, 30)
subplot(222)
polyFit(xleft, pcl_0deg.val, 8)
subplot(224)
polyFit(xright, pcl_90deg.val, 8)

% 3D Visualization
figure(2)
hist3(pcl_0deg.pos(:, 1:2))

% 2D data binning
[ux, ~, xidx] = unique(pcl_0deg.pos(:, 1));
[uy, ~, yidx] = unique(pcl_0deg.pos(:, 2));
% count the number of points at each unique x/y combination
counts = accumarray([xidx(:), yidx(:)], 1); 
%average the z that fall into each unique x/y combination
avgs = accumarray([xidx(:), yidx(:)], pcl_0deg.val);
figure(3)
surf(avgs)


conv_filter_size = 10;
filter = ones(conv_filter_size)/(conv_filter_size*conv_filter_size);
weightedavgs = counts.*avgs;
weighted_avgs_smoothed = conv2(weightedavgs, filter, 'same');
counts_smoothed = conv2(counts, filter, 'same');
out = weighted_avgs_smoothed./counts_smoothed;
surf(out)


%create a list of the z that fall into each unique x/y combination
zs = accumarray([xidx(:), yidx(:)], pcl_0deg.val, [], @(V) {V}, {});
