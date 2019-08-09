function [pos] = CentroidVol(maskedVol)
    pcl.pos(isnan(pcl.val), :) = [];
    pcl.val(isnan(pcl.val)) = [];
    pos = mean(pcl.pos);
end

