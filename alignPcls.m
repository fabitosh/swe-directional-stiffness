function [pcl_0deg, pcl_90deg] = alignPcls(pcl_0deg,pcl_90deg)
    %% Initial Rotation
    R1 = [1, 0, 0; 0, 1, 0; 0, 0, 1];   % no rotation
    R2 = [0, -1, 0; 1, 0, 0; 0, 0, 1];  % +90deg around z
    R3 = [0, 1, 0; -1, 0, 0; 0, 0, 1]; % -90deg around z
    pcl_90deg.pos = (R2 * pcl_90deg.pos.')';

    %% Align volumes using PCA
    % Calculate Centroids
    center_0deg = round(centroidPcl(pcl_0deg));
    center_90deg = round(centroidPcl(pcl_90deg));
    pcl_0deg.pos = pcl_0deg.pos - center_0deg;
    pcl_90deg.pos = pcl_90deg.pos - center_90deg;

    % Masks are identical. Thus alignment over Principle Components.
    R_I0 = sortPcaRot(pca(pcl_0deg.pos));
    R_I90 = sortPcaRot(pca(pcl_90deg.pos));
    % T_Izero  = [R_Izero,  center_0deg';  zeros(1, 3), 1];
    % T_Ininty = [R_Ininty, center_90deg'; zeros(1, 3), 1];
    % Determine Angle between the PCA Main Component Coordinate Systems
    % We only want to align volumes to each other and not change the introduced
    % coordinate system.
    R_nintyzero = (R_I90' * R_I0)'; % R_(90,I)*R_
    transl_nintyzero = zeros(1,3); %center_0deg - center_90deg;

    % Homogeneous Transformation Matrix
    T_nintyzero = [R_nintyzero, zeros(3, 1); transl_nintyzero, 1];

    % Compute new coordinates
    rotpos = [pcl_90deg.pos, ones(size(pcl_90deg.pos, 1), 1)] * T_nintyzero;
    pcl_90deg.pos = round(rotpos(:, 1:3));
end

function M = sortPcaRot(rot)
    s = size(rot);
    M = NaN(s);
    for row = 1:s
        id_colmax = 1;
        for col = 1:s
            if rot(row, col) > rot(row, id_colmax)
                id_colmax = col;
            end
        end
        M(:, row) = rot(:, id_colmax);
    end
end

