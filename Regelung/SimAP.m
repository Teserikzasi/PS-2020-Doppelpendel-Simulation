%function [simout,results] = SimAP(simparams)
% Simuliert eine AP-Regelung

Tsim = 10;

disp(['Simuliere AP-Regelung (AP ' int2str(simparams.AP.i) ')' ])
out = sim('AP_Regelung_Test', Tsim);

results = APAuswertung(out)
%results.xend_norm

if results.stabilised
    disp('Um AP stabilisiert')
else
    disp(['AP wurde nicht stabilisiert. Abweichung:'])
    results.xend
end

fprintf('Maximal: x %f, phi1 %f, phi2 %f\n', results.x(1).max, results.x(3).max, results.x(5).max)

Auswertung

%end