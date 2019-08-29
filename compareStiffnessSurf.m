function [f] = compareStiffnessSurf(pcl1, pcl2, conv_filter_size)
% Creates a visualisation to compare two pointclouds. 
% Both are processed by computeSmoothed2DStiffness(). Their processed
% visualised outputs are then compared in one bird view figure.

    %% Process the pointclouds
    stiffnessarray1 = computeSmoothed2DStiffness(pcl1, conv_filter_size);
    stiffnessarray2 = computeSmoothed2DStiffness(pcl2, conv_filter_size);
    
    %% Visualise comparison
    f = figure();
    set(gcf,'position',[10,100,1600,800])
    subplot(121)
    s = surf(stiffnessarray1);
    s.EdgeColor = 'none';
    view(0,90)
    subplot(122)
    s = surf(stiffnessarray2);
    s.EdgeColor = 'none';
    view(0,90)
end

