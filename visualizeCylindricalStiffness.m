function visualizeCylindricalStiffness(pcl)
    x = pcl.pos_cyl(:, 2);
    y = pcl.val;
    
    % Binscatter
    figure(1)
    title("Binscatter");
    binscatter(x, y, 50);
    
    % Polyfit
    figure(2)
    scatter(x, y);
    hold on;
    p = polyfit(x, y, 8);
    xsorted = sort(x);
    yp = polyval(p,xsorted);
    plot(x,yp,'r-')
    
    %
    
end

