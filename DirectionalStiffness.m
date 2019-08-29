%% Set directory to save output files
plotpath = 'uberplots/';
if ~exist(plotpath, 'dir')
  mkdir(plotpath);
end

%% Loop over folder
datapath = '/Users/fabiomeier/Documents/MATLAB/Maskedvolume_SWE/';
files = dir(strcat(datapath,'*.mat'));
L = length(files);

% files = datadir('*.mat');
for file = 1:L
    %% Load MaskedVolume Files
    name_base = file.name;
    % name_0deg =
    % name_90deg =

    vol_0deg = load('MaskedVolume_SWE_C190201_L3L4_0deg_2019_07_31_15_3.mat');
    vol_0deg = vol_0deg.masked_vol;
    vol_90deg = load('MaskedVolume_SWE_C190201_L3L4_90deg_2019_07_31_15_4.mat');
    vol_90deg = vol_90deg.masked_vol;

    %% Transform into Pointcloud
    pcl_0deg = volumeToPointcloud(vol_0deg);
    pcl_90deg = volumeToPointcloud(vol_90deg);

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

    %% Calculate Centroids and shift x-y coordinates
    center_0deg = round(centroidPcl(pcl_0deg));
    center_90deg = round(centroidPcl(pcl_90deg));
    pcl_0deg.pos(:, 1:2) = pcl_0deg.pos(:, 1:2) - center_0deg(1:2);  % Keep z coordinate original
    pcl_90deg.pos(:, 1:2) = pcl_90deg.pos(:, 1:2) - center_90deg(1:2);  % Keep z coordinate original

    %% Create cylindrical coordinate system coordinates around centroids
    % pcl_0deg.pos_cyl is set up in [rho, theta, z]
    [pcl_0deg.pos_cyl(:, 2), pcl_0deg.pos_cyl(:, 1)] = cart2pol(pcl_0deg.pos(:, 1),pcl_0deg.pos(:, 2));
    pcl_0deg.pos_cyl(:, 3) = pcl_0deg.pos(: , 3);

    [pcl_90deg.pos_cyl(:, 2), pcl_90deg.pos_cyl(:, 1)] = cart2pol(pcl_90deg.pos(:, 1),pcl_90deg.pos(:, 2));
    pcl_90deg.pos_cyl(:, 3) = pcl_90deg.pos(: , 3);

    %% ////// Visualise Results //////
    %% 2D Plots in Cylindrical coordinates
    % Plot angle or radius against stiffness

    % ######## Change visualisation parameters from here on ########
    % .pos_cyl(:, 1) are rho/r values, .pos_cyl(:, 2) are theta/angle values
    % xtop = pcl_0deg.pos_cyl(:, 3); 
    % xbot = pcl_90deg.pos_cyl(:, 3);
    % figure()
    % subplot(221)
    % binnedDataVisualisation(xtop, pcl_0deg.val, 30, 'z-Value');
    % subplot(223)
    % binnedDataVisualisation(xbot, pcl_90deg.val, 30, 'z-Value');
    % subplot(222)
    % polyFit(xtop, pcl_0deg.val, 3);
    % subplot(224)
    % polyFit(xbot, pcl_90deg.val, 3);

    %% 3D Visualizations
    % Those work with the carthesian coordinate system

    plot2DStiffness(computeSmoothed2DStiffness(pcl_0deg, 1.5)); % Only look at one scan
    compareStiffnessSurf(pcl_0deg, pcl_90deg, 1.5); % Compare 0 and 90 degree scans

    %% UEBERPLOT
    figure
    set(gcf,'position',[10,100,1600,800])
    title('Experiment Name') 
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
    binnedDataVisualisation(pcl_90deg.pos_cyl(:, 3), pcl_90deg.val, 30, 'Angle - 90deg Scan');
    subplot(244)
    s = surf(computeSmoothed2DStiffness(pcl_0deg, 2));
    s.EdgeColor = 'none';
    axis equal
    view(0,90)
    subplot(248)
    s = surf(computeSmoothed2DStiffness(pcl_90deg, 2));
    s.EdgeColor = 'none';
    axis equal
    view(0,90)
    saveas(gcf,[name_base, '.png'])
    saveas(gcf,[name_base, '.fig'])
end
