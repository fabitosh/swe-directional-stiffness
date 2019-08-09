function [pos] = CentroidVol(maskedVol)
    m1mask = maskedVol == -1;
    maskedVol(m1mask) = NaN;
    pcl = VolumeToPointcloud(maskedVol);
    pcl.pos(isnan(pcl.val), :) = [];
    pcl.val(isnan(pcl.val)) = [];
    pos = mean(pcl.pos);
end

