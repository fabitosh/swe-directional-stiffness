function [max_radii, angles] = getSmoothedPolarMask(...
    pcl, mma_size, angle_resolution)
% Computes a smoothed boundary of the pointcloud. Requires the pcl to
% be centered for the usage of cylindrical coordinates
    % Input Args handling
    switch nargin
        case 1
            angle_resolution = 100;
            mma_size = 10;
        case 2
            angle_resolution = 150;
    end

    % Compute Cylindrical Coords for the pcl if they don't exist yet
    if ~isfield(pcl,'pos_cyl')
        [pcl.pos_cyl(:, 2), pcl.pos_cyl(:, 1)] = ...
            cart2pol(pcl.pos(:, 1),pcl.pos(:, 2));
        pcl.pos_cyl(:, 3) = pcl.pos(: , 3);
    end
    
    angles = linspace(-pi, pi, angle_resolution)';
    max_radii = NaN(angle_resolution, 1);
    thetas = pcl.pos_cyl(:, 2);
    
    % Can't sort pcl as the used structure depends on the indexes =( 
    for ii = 2:angle_resolution
        lower = angles(ii-1);
        upper = angles(ii);
        max_r = max(pcl.pos_cyl((thetas>lower & thetas<upper), 1));
        if ~isempty(max_r)
            max_radii(ii) = max_r;
        else
            max_radii(ii) = max_radii(ii-1);
        end
    end
        
    figure()
    polarplot(angles, max_radii); hold on
    max_radii = nan_mma(max_radii, mma_size);
    polarplot(angles, max_radii)
end
