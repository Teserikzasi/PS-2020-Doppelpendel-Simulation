function plot_x0_vergleich(x0_APs, leg)
% Plottet die x0_Tests von den kritischen APs mehrerer Konfigurationen

for i=1:length(x0_APs)  % Umsortieren zum Plotvergleich
    ap2(i)  = x0_APs(i).ap2;
    ap3(i)  = x0_APs(i).ap3;
    ap41(i) = x0_APs(i).ap41;
    ap42(i) = x0_APs(i).ap42;
end

plot_x0_AP_dmax(ap2,  leg, 'Maximalabweichungen AP 2 (Auslenkung \phi_2)' )
plot_x0_AP_dmax(ap3,  leg, 'Maximalabweichungen AP 3 (Auslenkung \phi_1)' )
plot_x0_AP_dmax(ap41, leg, 'Maximalabweichungen AP 4 (Auslenkung \phi_1)' )
plot_x0_AP_dmax(ap42, leg, 'Maximalabweichungen AP 4 (Auslenkung \phi_2)' )

plot_x0_AP_guete(ap2,  leg, 'Gütemaße AP 2 (Auslenkung \phi_2)' )
plot_x0_AP_guete(ap3,  leg, 'Gütemaße AP 3 (Auslenkung \phi_1)' )
plot_x0_AP_guete(ap41, leg, 'Gütemaße AP 4 (Auslenkung \phi_1)' )
plot_x0_AP_guete(ap42, leg, 'Gütemaße AP 4 (Auslenkung \phi_2)' )

end