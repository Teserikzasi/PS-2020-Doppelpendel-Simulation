function res_y = QR_Variation(AP, riccdata, vari, range, y_sel, y_step)
% Variiert einen Q oder R Parameter in dem angegebenen Bereich und wertet
% die x0 Tests aus
% vari: Parameter 'R' oder 'Qi'
% range: Testbereich für den Parameter
% y_sel: Führt nur Auslenkungen von (x,phi1,phi2) aus (1,2,3) (optional)
% y_step: Schrittweite für x0 Test (optional)

if ~exist('y_sel', 'var')
    y_sel = 1:3;
end
if ~exist('y_step', 'var')
    y_step = [0.2, deg2rad(2), deg2rad(2)];
end

ausl = ["x", "\phi_1", "\phi_2"];

QorR = vari(1);
if QorR=='Q'
    Qii = str2num(vari(2));
end

i=1;
for P=range
    fprintf('%s = %f\n', vari, P)
    if QorR=='R'
        riccdata(AP).R = P;
    else
        riccdata(AP).Q(Qii,Qii) = P;
    end
    InitAPRegData(riccdata)
    for j=y_sel
        step = [0,0,0];
        step(j) = y_step(j);
        res_y(j,i) = x0_Test(AP, step, false );
    end
    i=i+1;
end

for j=y_sel
    titl = sprintf('AP %d (Auslenkung %s)  Variation: %s', AP, ausl(j), vari );
    plot_x0max_param(res_y(j,:), range, vari, titl, true)
    plot_x0_ymax(res_y(j,:), range, titl )
    plot_x0_guete(res_y(j,:), range, titl )
    plot_x0_xin(res_y(j,:), range, titl )
end

end