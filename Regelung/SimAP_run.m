
%testAP = 3;
%delta_x0 = [0 0 deg2rad(5) 0 deg2rad(10) 0];

[out, results] = SimAP(testAP, delta_x0 );

fprintf('Maximal: x: %.3f, phi1: %.2f°, phi2: %.2f°\n', ...
    results.x(1).max, rad2deg(results.x(3).max), rad2deg(results.x(5).max) )
fprintf('Gütemaße:  Jx = %.2f, Jxest = %.2f, Jf = %.0f\n', ...
    results.Jx, results.Jxest, results.Jf )

Auswertung(out)

plotanimate(out)

%SimAP_x0_Test( testAP, 0, deg2rad(0), deg2rad(5), true )
