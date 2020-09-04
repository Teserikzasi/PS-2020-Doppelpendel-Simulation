function [simout, results] = SimAP(testAP, delta_x0, Tsim)
% Simuliert eine AP-Regelung mit gegebenem AP und x0

if ~exist('Tsim', 'var')
    Tsim = 10;
end

global simparams;
global APRegData;
global Ruhelagen;
global Zustandsermittlung;
simparams.AP = Ruhelagen(testAP);
simparams.gesamtmodell.schlittenpendel.x0 = Ruhelagen(testAP).x' + delta_x0;
simparams.APRegDataA = APRegData.A(testAP);
simparams.APRegDataF = APRegData.F(testAP);
simparams.APRegDataA.xb0 = delta_x0';
simparams.APRegDataF.xb0 = delta_x0';

fprintf('\nSimuliere AP-Regelung (AP %d)...   Zustandsermittlung: %s\n', ...
    simparams.AP.i, Zustandsermittlung(simparams.Zustandsermittlung) )
%   Vorsteuerung: c = %d, d = %d , ...    simparams.vorst.C, simparams.vorst.D
fprintf('delta x0:  x = %.2f  phi1 = %.0f°  phi2 = %.0f°\n', ...
    delta_x0(1), rad2deg(delta_x0(3)), rad2deg(delta_x0(5)) )

simout = sim('AP_Regelung_Test', Tsim);
results = APAuswertung(simout);

if results.stabilised
    disp('Um AP stabilisiert')
else
    fprintf('AP wurde NICHT stabilisiert. Abweichung:  x = %.2f  phi1 = %.0f°  phi2 = %.0f°\n', ...
        results.xend(1), rad2deg(results.xend(3)), rad2deg(results.xend(5)) )
end

end