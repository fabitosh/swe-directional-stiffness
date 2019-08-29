function [f] = plot2DStiffness(smoothed_stiffness_array)
% Creates a plot of a matrix (e.g. the output of computeSmoothed2DStiffness()) 
    f = figure();
    set(gcf,'position',[10,100,1600,800])
    subplot(121)
    surf(smoothed_stiffness_array)
    subplot(122)
    surf(smoothed_stiffness_array)
    view(0,90)
end

