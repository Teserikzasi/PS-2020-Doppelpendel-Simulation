function plot_x0_APs(x0_APs, leg, vari)
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

if exist('vari', 'var')
    ap2title  = [ap2title  '  Variation: ' vari];
    ap3title  = [ap3title  '  Variation: ' vari];
    ap41title = [ap41title '  Variation: ' vari];
    ap42title = [ap42title '  Variation: ' vari];
    
    plot_x0max_param(ap2,  leg, vari, ap2title)
    plot_x0max_param(ap3,  leg, vari, ap3title)
    plot_x0max_param(ap41, leg, vari, ap41title)
    plot_x0max_param(ap42, leg, vari, ap42title)
end

plot_x0_ymax(ap2,  leg, ap2title )
plot_x0_ymax(ap3,  leg, ap3title )
plot_x0_ymax(ap41, leg, ap41title )
plot_x0_ymax(ap42, leg, ap42title )

plot_x0_guete(ap2,  leg, ap2title )
plot_x0_guete(ap3,  leg, ap3title )
plot_x0_guete(ap41, leg, ap41title )
plot_x0_guete(ap42, leg, ap42title )

plot_x0_xin(ap2,  leg, ap2title )
plot_x0_xin(ap3,  leg, ap3title )
plot_x0_xin(ap41, leg, ap41title )
plot_x0_xin(ap42, leg, ap42title )

end