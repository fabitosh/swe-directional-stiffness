% Load Files
vol_0deg = load('MaskedVolume_SWE_C190201_L3-L4_0deg_2019_07_31_15_3.mat');
vol_0deg = vol_0deg.masked_vol;
vol_90deg = load('MaskedVolume_SWE_C190201_L3-L4_90deg_2019_07_31_15_4.mat');
vol_90deg = vol_90deg.masked_vol;

% Transform into Pointcloud
pcl_0deg = volumeToPointcloud(vol_0deg);
pcl_90deg = volumeToPointcloud(vol_90deg);

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

%% Rotation experiments
R1 = [1, 0, 0; 0, 1, 0; 0, 0, 1];   % no rotation
R2 = [0, -1, 0; 1, 0, 0; 0, 0, 1];  % +90deg around z
R3 = [0, 1, 0; -1, 0, 0; 0, 0, 1]; % -90deg around z
pcl_90deg.pos = (R2 * pcl_90deg.pos.')';


%% Align volumes using PCA
% Calculate Centroids
center_0deg = centroidPcl(pcl_0deg);
center_90deg = centroidPcl(pcl_90deg);
pcl_0deg.pos = pcl_0deg.pos - center_0deg;
pcl_90deg.pos = pcl_90deg.pos - center_90deg;

% Masks are identical. Thus alignment over Principle Components.
R_I0 = pca(pcl_0deg.pos);
R_I90 = pca(pcl_90deg.pos);
% T_Izero  = [R_Izero,  center_0deg';  zeros(1, 3), 1];
% T_Ininty = [R_Ininty, center_90deg'; zeros(1, 3), 1];
% Determine Angle between the PCA Main Component Coordinate Systems
% We only want to align volumes to each other and not change the introduced
% coordinate system.
R_nintyzero = (R_I90' * R_I0)';
transl_nintyzero = zeros(1,3); %center_0deg - center_90deg;

% Homogeneous Transformation Matrix
T_nintyzero = [R_nintyzero, zeros(3, 1); transl_nintyzero, 1];

% Compute new coordinates
rotpos = [pcl_90deg.pos, ones(size(pcl_90deg.pos, 1), 1)] * T_nintyzero;
pcl_90deg.pos = rotpos(:, 1:3);

%% Visualize the wobababu
figure()
subplot(221)
scatter(pcl_0deg.pos(:, 1), pcl_0deg.pos(:, 3),'.'); hold on;
scatter(pcl_90deg.pos(:, 1), pcl_90deg.pos(:, 3),'.'); hold off;
legend('0 deg', '90 deg');
xlabel('x-Axis')
ylabel('z-Axis')
title("xz")
axis equal;
subplot(222)
scatter(pcl_0deg.pos(:, 2), pcl_0deg.pos(:, 3),'.'); hold on;
scatter(pcl_90deg.pos(:, 2), pcl_90deg.pos(:, 3),'.'); hold off;
xlabel('y-Axis')
ylabel('z-Axis')
title("yz")
axis equal;
subplot(223)
scatter(pcl_0deg.pos(:, 1), pcl_0deg.pos(:, 2),'.'); hold on;
scatter(pcl_90deg.pos(:, 1), pcl_90deg.pos(:, 2),'.'); hold off;
xlabel('x-Axis')
ylabel('y-Axis')
title("xy")
axis equal;
subplot(224)
scatter3(pcl_0deg.pos(:, 1), pcl_0deg.pos(:, 2), pcl_0deg.pos(:, 3),'.'); hold on;
scatter3(pcl_90deg.pos(:, 1), pcl_90deg.pos(:, 2), pcl_90deg.pos(:, 3),'.'); hold off;
xlabel('x-Axis')
ylabel('y-Axis')
zlabel('z-Axis')
title("3D View")
axis equal;