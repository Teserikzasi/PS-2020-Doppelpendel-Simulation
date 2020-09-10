function res = x0_Test_APs(stepdeg)
% Macht die kritischen Anfangswert-Tests für AP 2,3,4

if ~exist('step', 'var')
    stepdeg=1;
end

global simparams;
global Zustandsermittlung;
fprintf('\nKritische Anfangswert-Tests (AP2 phi2, AP3 phi1, AP4 phi1, AP4 phi2) ...\n')
fprintf('Zustandsermittlung: %s\n', Zustandsermittlung(simparams.Zustandsermittlung))

[res.ap2.max_y0,  res.ap2.y_max,  res.ap2.guete ] = x0_Test(2, [0, 0, deg2rad(stepdeg)], false ); % Pendel 2 instabil
[res.ap3.max_y0,  res.ap3.y_max,  res.ap3.guete ] = x0_Test(3, [0, deg2rad(stepdeg), 0], false ); % Pendel 1 instabil
[res.ap41.max_y0, res.ap41.y_max, res.ap41.guete] = x0_Test(4, [0, deg2rad(stepdeg), 0], false );
[res.ap42.max_y0, res.ap42.y_max, res.ap42.guete] = x0_Test(4, [0, 0, deg2rad(stepdeg)], false );

disp(' ')
fprintf('AP2 max phi20 = %.0f°\n', rad2deg(res.ap2.max_y0(3)) )
fprintf('AP3 max phi10 = %.0f°\n', rad2deg(res.ap3.max_y0(2)) )
fprintf('AP4 max phi10 = %.0f°\n', rad2deg(res.ap41.max_y0(2)) )
fprintf('AP4 max phi20 = %.0f°\n', rad2deg(res.ap42.max_y0(3)) )

end
%x0_Test( testAP, [0, deg2rad(0), deg2rad(2)], true, true )