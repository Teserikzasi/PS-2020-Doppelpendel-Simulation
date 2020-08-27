
% Simuliert nacheinander immer höhere Anfangswerte bis zur Instabilität

testAP = 2;
fprintf('Sim AP %d Anfangswert-Test...  Zustandsermittlung: %s\n', testAP, Zustandsermittlung(simparams.Zustandsermittlung))
x_st = 0;
phi1_st = deg2rad(0);
phi2_st = deg2rad(5);

i=0;
while (i==0 || results.stabilised)
    dx = x_st*i;
    dphi1 = phi1_st*i;
    dphi2 = phi2_st*i;
    [simout, results] = SimAP(testAP, [dx 0 dphi1 0 dphi2 0] );
    plot_outputs(simout)
    i=i+1;
end
