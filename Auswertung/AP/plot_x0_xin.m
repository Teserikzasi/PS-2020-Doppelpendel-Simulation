function plot_x0_xin(data,leg,titl)
% Plottet die Einschwingzeiten des Anfangswerttest
% data: Ein oder mehrere structs mit xnorm_in und max_y0

ylab = "t_{in} [s]";
xlab = ["x_0 [m]","\phi_{1,0} [°]","\phi_{2,0} [°]"];

l = length(data);
[~ , x0varidx] = max(data(1).max_y0+data(end).max_y0);  % Bestimmung der variierten Variable

figure
grid on
hold on
if l>4
    colororder([linspace(1,0.8,l)' linspace(0,0.7,l)' linspace(0,0,l)'])
end

for j=1:l
    x0varmax = data(j).max_y0(x0varidx);  % max Auslenkung von data j
    if x0varidx>1  % Winkel
        x0varmax = rad2deg(x0varmax);
    end
    xin = data(j).xnorm_in;
    plot([linspace(0,x0varmax,length(xin)) x0varmax], [xin 0], 'o-')
end

legend(string(leg))
ylabel(ylab)
xlabel(xlab(x0varidx))
title(['Einschwingzeiten ' titl])

end