%% Set directory to save output files
plotpath = 'all_visualisations/';
if ~exist(plotpath, 'dir')
  mkdir(plotpath);
end

%% Loop over experiment folder
datapath = '/Users/fabiomeier/Documents/MATLAB/Maskedvolume_SWE/';
files = dir(strcat(datapath,'*.mat'));
L = length(files);

for ii = 1:2:L
    %% Get corresponding Experiment Pair out of Dataset
    str = split(files(ii).name, "_");
    str2 = split(files(ii+1).name, "_");
    basename = join([str(3), str(4)], "_");
    disp(basename)
    if strcmp(str(5), "0deg") 
        name_0deg = files(ii).name;
        if strcmp(str(3), str2(3)) && strcmp(str(4), str2(4))
            name_90deg = files(ii+1).name;
            disp(name_0deg)
            disp(name_90deg)
        else
            disp('Experiment Files do not match! Make sure they are ordered alphabetically and all experiments have a 0deg and 90deg scan');
            return
        end
    else
        disp('First file of index uneven (1, 3, ...) was not with a 0deg orientation.')
        return
    end
    
    %% Load MaskedVolume Files
    vol_0deg_mask = load([datapath name_0deg]);
    vol_0deg_mask = vol_0deg_mask.masked_vol;
    vol_90deg_mask = load([datapath name_90deg]);
    vol_90deg_mask = vol_90deg_mask.masked_vol;

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
    length(pcl_0deg.pos)
    
    pcl_0deg.pos(pcl_0deg.val == -1, :) = [];
    pcl_0deg.val(pcl_0deg.val == -1, :) = [];
    pcl_90deg.pos(pcl_90deg.val == -1, :) = [];
    pcl_90deg.val(pcl_90deg.val == -1, :) = [];
    length(pcl_0deg.pos)

    %% Create cylindrical coordinate system coordinates around centroids
    % pcl_0deg.pos_cyl is set up in [rho, theta, z]
    [pcl_0deg.pos_cyl(:, 2), pcl_0deg.pos_cyl(:, 1)] = cart2pol(pcl_0deg.pos(:, 1),pcl_0deg.pos(:, 2));
    pcl_0deg.pos_cyl(:, 3) = pcl_0deg.pos(: , 3);

    [pcl_90deg.pos_cyl(:, 2), pcl_90deg.pos_cyl(:, 1)] = cart2pol(pcl_90deg.pos(:, 1),pcl_90deg.pos(:, 2));
    pcl_90deg.pos_cyl(:, 3) = pcl_90deg.pos(: , 3);

    %% ////// Visualise Results //////

    % polyFit(xbot, pcl_90deg.val, 3);
    %% 3D Visualizations
    % Those work with the carthesian coordinate system
%     plot2DStiffness(computeSmoothed2DStiffness(pcl_0deg, 1.5)); % Only look at one scan
%     compareStiffnessSurf(pcl_0deg, pcl_90deg, 1.5); % Compare 0 and 90 degree scans

    %% UEBERPLOT
    figure('visible','off')
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
    binnedDataVisualisation(pcl_90deg.pos_cyl(:, 3), pcl_90deg.val, 30, 'Height - 90deg Scan');
    subplot(244)
    surf(computeMaskArray(pcl_0deg_masked), 'FaceColor', 'k')
    s = surf(computeSmoothed2DStiffness(pcl_0deg, 2));
    s.EdgeColor = 'none';
    colorbar
    axis equal
    view(0,90)
    subplot(248)
    surf(computeMaskArray(pcl_90deg_masked), 'FaceColor', 'k')
    surf(computeSmoothed2DStiffness(pcl_90deg_masked, 0))
    s = surf(computeSmoothed2DStiffness(pcl_90deg_masked, 2));
    s.EdgeColor = 'none';
    colorbar
    axis equal
    view(0,90)
    path_png = char(fullfile(plotpath, join([basename, '.png'], "")));
    path_fig = char(fullfile(plotpath, join([basename, '.fig'], "")));
    saveas(gcf, path_png);
%     saveas(gcf, path_fig);
    
end

figure
contourf(computeMaskArray(pcl_90deg_masked)); colormap(gray); hold on;
colormap(jet);
contourf(computeSmoothed2DStiffness(pcl_90deg, 2))
