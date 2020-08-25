
% Simuliert nacheinander immer höhere Anfangswerte bis zur Instabilität

testAP = 2;
fprintf('Sim AP %d phi0...  Zustandsermittlung: %s\n', testAP, Zustandsermittlung(simparams.Zustandsermittlung))
phi1_st = 0/180*pi;
phi2_st = 5/180*pi;

i=0;
while (i==0 || results.stabilised)
    dphi1 = phi1_st*i;
    dphi2 = phi2_st*i;
    disp(' ')
    fprintf('delta x0:  dphi1 = %.0f°, dphi2 = %.0f°\n', dphi1*180/pi, dphi2*180/pi)
    [simout, results] = SimAP(testAP, [0 0 dphi1 0 dphi2 0] );
    plot_outputs(simout)
    i=i+1;
end
