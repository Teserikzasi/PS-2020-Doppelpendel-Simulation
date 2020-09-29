function plot_x0_guete(data,leg,titl)
% Plottet die Gütemaße Auswertung des Anfangswerttest
% data: Ein oder mehrere structs mit guete und max_y0

ylab = ["Jx","Jx_{est}","Jf"];
xlab = ["x_0 [m]","\phi_{1,0} [°]","\phi_{2,0} [°]"];

l = length(data);
[~ , x0varidx] = max(data(1).max_y0+data(end).max_y0);  % Bestimmung der variierten Variable

figure
if l>5
    colororder([linspace(0,0.9,l)' linspace(0,0,l)' linspace(1,0.1,l)'])
end

for i=1:3
    subplot(3,1,i)
    hold on
    grid on
    for j=1:l
        x0varmax = data(j).max_y0(x0varidx);  % max Auslenkung von data j
        if x0varidx>1  % Winkel
            x0varmax = rad2deg(x0varmax);
        end
        guete = data(j).guete(:,i);
        plot([linspace(0,x0varmax,length(guete)) x0varmax], [guete' 0], 'o-')
    end
    ylabel(ylab(i))
    if i==1
        title(['Gütemaße ' titl])
        legend(string(leg))
    end
end

xlabel(xlab(x0varidx))

end