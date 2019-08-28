function polyFit(x, y, order_polynom)
    title(["Polyfit of order ", string(order_polynom)]);
    scatter(x, y);
    hold on;
    p = polyfit(x, y, order_polynom);
    xsorted = sort(x);
    yp = polyval(p,xsorted);
    plot(xsorted,yp,'r-')
end

