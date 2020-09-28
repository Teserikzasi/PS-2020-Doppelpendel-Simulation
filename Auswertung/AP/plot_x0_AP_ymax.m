function plot_x0_AP_ymax(data,leg,titl)
% Plottet die Maximalabweichungen des Anfangswerttest
% data: Ein oder mehrere structs mit y_max und max_y0

ylab = ["x_{max} [m]","\phi_{1max} [°]","\phi_{2max} [°]"];
y0leg = ["x_0","\phi_{1,0}","\phi_{2,0}"];
xlab = ["x_0 [m]","\phi_{1,0} [°]","\phi_{2,0} [°]"];
%col = [ [0 0.4470 0.7410]  [0.9290, 0.6940, 0.1250]  [0.4660, 0.6740, 0.1880]

[~ , x0varidx] = max(data(1).max_y0);  % Bestimmung der variierten Variable

figure

for i=1:3
    subplot(3,1,i)
    hold on
    grid on
    x0varmaxx=0;
    y0imaxx=0;
    for j=1:length(data)
        x0varmax = data(j).max_y0(x0varidx);  % max Auslenkung von data j
        if x0varidx>1  % Winkel
            x0varmax = rad2deg(x0varmax);
        end
        if x0varmax>x0varmaxx
            x0varmaxx = x0varmax;
        end
        y0imax = data(j).max_y0(i);
        ymax = data(j).y_max(:,i);
        if i>1  % Winkel
            y0imax = rad2deg(y0imax);
            ymax = rad2deg(ymax);
        end
        if y0imax>y0imaxx
            y0imaxx = y0imax;
        end
        plot([linspace(0,x0varmax,length(ymax)) x0varmax], [ymax' 0], ...
            'o-')%, 'Color',  )
    end
    plot([0 x0varmaxx],[0 y0imaxx], 'k' )  % Linie Anfangswert
    legend([leg y0leg(i)])
    ylabel(ylab(i))
    if i==1
        title(['Maximalabweichungen ' titl])
    end
end

xlabel(xlab(x0varidx))

end