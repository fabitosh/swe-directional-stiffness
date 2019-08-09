function [ptcl] = VolumeToPointcloud(vox_volume)
%Creates a pointcloud (x/y/z triplets with intensity) of a voxel volume
    %   Minimum position is (1/1/1) and maximum position is size(image)
    % ptcl: Struct with .pos and .val
    %% Get volume parameters
    [sizelist(1,1), sizelist(2,1), sizelist(3,1)] = size(vox_volume);
    %Number of points in total
    nbpix = prod(sizelist);
    %Initialize pointcloud struct
    ptcl.pos = zeros(nbpix,3);
    ptcl.val = zeros(nbpix,1);
    %% Create unscaled pointcloud positions
    [xgrid, ygrid, zgrid] = meshgrid(...
        1 : sizelist(2,1), 1 : sizelist(1,1), 1 : sizelist(3,1)); 
    xpos_list = reshape(xgrid, nbpix, 1);
    ypos_list = reshape(ygrid, nbpix, 1);
    zpos_list = reshape(zgrid, nbpix, 1);
    ptcl.pos = [xpos_list, ypos_list, zpos_list];
    %% Map pixel intensities to points 
    ptcl.val = reshape(vox_volume, nbpix, 1);
end

