function polyFit(x, y, order_polynom)
% Finds a polynom of order_polynom to describe the relation between x and y
% with a minimum residual error.
% Plots original scatter of all points and overlays the polynom.

    %% Find polynom
    p = polyfit(x, y, order_polynom);
    
    %% Visualise Polynom over scattered data
    title(["Polyfit of order ", string(order_polynom)]);
    scatter(x, y, 1, 'filled');
    hold on;
    xsorted = sort(x);
    yp = polyval(p,xsorted);
    plot(xsorted,yp,'r-')
end

