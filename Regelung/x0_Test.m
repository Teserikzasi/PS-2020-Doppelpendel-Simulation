function res = x0_Test(AP, y_st, plotres, plotall)
% Simuliert nacheinander immer höhere Anfangswerte bis zur Instabilität
% y_st = [x_st, phi1_st, phi2_st]

if ~exist('plotall', 'var')
    plotall=false;
end
if ~exist('plotres', 'var')
    plotres=true;
end

Tsim = 10;
x_st    = y_st(1);
phi1_st = y_st(2);
phi2_st = y_st(3);

fprintf('\nAnfangswert-Test AP %d ...\n', AP )
fprintf('Step delta y0:  x = %.2f  phi1 = %.0f°  phi2 = %.0f°\n', ...
    x_st, rad2deg(phi1_st), rad2deg(phi2_st) )

i=0;
res.y_max=[0 0 0];
res.guete=[0 0 0];
res.xnorm_in=0;
while (true)
    dx0    = i*x_st;
    dphi10 = i*phi1_st;
    dphi20 = i*phi2_st;
    if dx0>2 || dphi10>deg2rad(45) || dphi20>deg2rad(45) % abbrechen um Zeit zu sparen
        break
    end
    [simout, results] = SimAP(AP, [dx0 0 dphi10 0 dphi20 0], Tsim, ~plotall );
    if plotall
        plot_outputs(simout)
    end
    if results.stabilised
        res.y_max(i+1,:) = [results.x(1).max, results.x(3).max, results.x(5).max];
        res.guete(i+1,:) = [results.Jx, results.Jxest, results.Jf];
        res.xnorm_in(i+1) = results.xnorm_ausw.tein;
    else
        break
    end
    i=i+1;
end

max_x0    = (i-1)*x_st;
max_phi10 = (i-1)*phi1_st;
max_phi20 = (i-1)*phi2_st;
res.max_y0 = [max_x0, max_phi10, max_phi20];
fprintf('Max delta y0:  x = %.2f  phi1 = %.0f°  phi2 = %.0f°\n', ...
    max_x0, rad2deg(max_phi10), rad2deg(max_phi20) )

if plotres
    plot_x0_Test(res.y_max,res.guete,AP)
end

end