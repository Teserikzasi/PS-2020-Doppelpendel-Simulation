function plot_x0max_param(data,param,par_xlab,titl,paramlog)
% Plottet die maximalen Startabweichungen in Abhängigkeit eines Parameters

ylab = ["x_{0max} [m]","\phi_{1,0max} [°]","\phi_{2,0max} [°]"];

l = length(data);
[~ , x0varidx] = max(data(1).max_y0+data(end).max_y0);  % Bestimmung der variierten Variable

figure

for j=1:l
    maxy0(j) = data(j).max_y0(x0varidx);
    if x0varidx>1  % Winkel
        maxy0(j) = rad2deg(maxy0(j));
    end
end

if exist('paramlog', 'var') && paramlog==true
    semilogx(param, maxy0, 'o-')
else
    plot(param, maxy0, 'o-')
end

grid on

ylabel(ylab(x0varidx))
xlabel(par_xlab)
%legend(string(leg))
title(['Max Startwerte ' titl])

end