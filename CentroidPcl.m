function [pos] = CentroidPcl(pcl)
    pcl.pos(isnan(pcl.val), :) = [];
    pcl.val(isnan(pcl.val)) = [];
    pos = mean(pcl.pos);
end

