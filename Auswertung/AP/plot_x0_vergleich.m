function plot_x0_vergleich(x0_APs, leg)
% Plottet die x0_Tests von den kritischen APs mehrerer Konfigurationen

for i=1:length(x0_APs)  % Umsortieren zum Plotvergleich
    ap2(i)  = x0_APs(i).ap2;
    ap3(i)  = x0_APs(i).ap3;
    ap41(i) = x0_APs(i).ap41;
    ap42(i) = x0_APs(i).ap42;
end

ap2title  = 'AP 2 (Auslenkung \phi_2)';
ap3title  = 'AP 3 (Auslenkung \phi_1)';
ap41title = 'AP 4 (Auslenkung \phi_1)';
ap42title = 'AP 4 (Auslenkung \phi_2)';

plot_x0_AP_ymax(ap2,  leg, ap2title )
plot_x0_AP_ymax(ap3,  leg, ap3title )
plot_x0_AP_ymax(ap41, leg, ap41title )
plot_x0_AP_ymax(ap42, leg, ap42title )

plot_x0_AP_guete(ap2,  leg, ap2title )
plot_x0_AP_guete(ap3,  leg, ap3title )
plot_x0_AP_guete(ap41, leg, ap41title )
plot_x0_AP_guete(ap42, leg, ap42title )

plot_x0_AP_xin(ap2,  leg, ap2title )
plot_x0_AP_xin(ap3,  leg, ap3title )
plot_x0_AP_xin(ap41, leg, ap41title )
plot_x0_AP_xin(ap42, leg, ap42title )

end