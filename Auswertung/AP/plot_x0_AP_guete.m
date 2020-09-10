function plot_x0_AP_guete(data,leg,titl)
% Plottet die Gütemaße Auswertung des Anfangswerttest
% data: Ein oder mehrere structs mit guete und max_y0

ylab = ["Jx","Jx_{est}","Jf"];
xlab = ["x_0 [m]","\phi_{1,0} [°]","\phi_{2,0} [°]"];

[~ , x0varidx] = max(data(1).max_y0);  % Bestimmung der variierten Variable

figure

for i=1:3
    subplot(3,1,i)
    hold on
    grid on
    for j=1:length(data)
        x0varmax = data(j).max_y0(x0varidx);  % max Auslenkung von data j
        if x0varidx>1  % Winkel
            x0varmax = rad2deg(x0varmax);
        end
        guete = data(j).guete(:,i);
        plot([linspace(0,x0varmax,length(guete)) x0varmax], [guete' 0], ...
            'o-')%, 'Color',  )
    end
    legend(leg)
    ylabel(ylab(i))
    if i==1
        title(titl)
    end
end

xlabel(xlab(x0varidx))

end