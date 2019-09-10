function [pcl_0deg, pcl_90deg] = alignPcls(pcl_0deg,pcl_90deg)
    %% Initial Rotation
    R1 = [1, 0, 0; 0, 1, 0; 0, 0, 1];   % no rotation
    R2 = [0, -1, 0; 1, 0, 0; 0, 0, 1];  % +90deg around z
    R3 = [0, 1, 0; -1, 0, 0; 0, 0, 1];  % -90deg around z
    pcl_90deg.pos = (R2 * pcl_90deg.pos.')';
    
    %% Centering
    % Calculate Centroids
    center_0deg = round(centroidPcl(pcl_0deg));
    center_90deg = round(centroidPcl(pcl_90deg));
    % Center Data
    pcl_0deg.pos = pcl_0deg.pos - center_0deg;
    pcl_90deg.pos = pcl_90deg.pos - center_90deg;

    %% Alignment over PCA.
    % Masks of both pointclouds are identical.
    % Requieres Pcls to be similarly aligned, e.g. rotated by R2 to remain
    % the interpretation through the original axes.
    
    R_I0 = sortPcaRot(pca(pcl_0deg.pos));
    R_I90 = sortPcaRot(pca(pcl_90deg.pos));
    % T_Izero  = [R_Izero,  center_0deg';  zeros(1, 3), 1];
    % T_Ininty = [R_Ininty, center_90deg'; zeros(1, 3), 1];
    
    % Determine Angle between the PCA Main Component Coordinate Systems
    % We only want to align volumes to each other and not change the introduced
    % coordinate system.
    % R_(90deg->0deg) = R_(90deg->I)*R_(I->0deg) = R_(I->90deg)'*R_(I->0deg)
    R_90_0 = (R_I90' * R_I0)'; 
    transl_90_0 = zeros(1,3); % Translation previously completed

    % Homogeneous Transformation Matrix
    T_90_0 = [R_90_0, zeros(3, 1); transl_90_0, 1];

    % Compute new coordinates
    rotpos = [pcl_90deg.pos, ones(size(pcl_90deg.pos, 1), 1)] * T_90_0;
    pcl_90deg.pos = round(rotpos(:, 1:3));
end

%% Reverts sorting the bases by importance and aligns with initial interpretation of axes
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

