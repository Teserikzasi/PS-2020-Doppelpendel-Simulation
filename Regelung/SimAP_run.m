
%testAP = 3;
%delta_x0 = [0 0 0 0 0.2 0];

fprintf('Zustandsermittlung: %s\n', Zustandsermittlung(simparams.Zustandsermittlung))
[out, results] = SimAP(testAP, delta_x0 );

fprintf('Maximal: x: %.3f, phi1: %.2f°, phi2: %.2f°\n', ...
    results.x(1).max, results.x(3).max*180/pi, results.x(5).max*180/pi)

Auswertung(out)

plotanimate(out)