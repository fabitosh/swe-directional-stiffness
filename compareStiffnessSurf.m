function [f] = compareStiffnessSurf(pcl1, pcl2, conv_filter_size)
    stiffnessarray1 = computeSmoothed2DStiffness(pcl1, conv_filter_size);
    stiffnessarray2 = computeSmoothed2DStiffness(pcl2, conv_filter_size);
    f = figure();
    set(gcf,'position',[10,100,1600,800])
    subplot(121)
    surf(stiffnessarray1)
    view(0,90)
    subplot(122)
    surf(stiffnessarray2)
    view(0,90)
end

