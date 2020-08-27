function [simout, results] = SimAP(testAP, delta_x0, Tsim)
% Simuliert eine AP-Regelung mit gegebenem AP und x0

if ~exist('Tsim', 'var')
    Tsim = 10;
end

global simparams;
global APRegDataA;
global APRegDataF;
global Ruhelagen;
global Zustandsermittlung;
simparams.AP = Ruhelagen(testAP);
simparams.APRegDataA = APRegDataA(testAP);
simparams.APRegDataF = APRegDataF(testAP);
simparams.gesamtmodell.schlittenpendel.x0 = Ruhelagen(testAP).x' + delta_x0;

fprintf('\nSimuliere AP-Regelung (AP %d) ...\n',  simparams.AP.i )
fprintf('Zustandsermittlung: %s   Vorsteuerung: c = %d, d = %d \n', ...
    Zustandsermittlung(simparams.Zustandsermittlung), ...
    simparams.vorst.C, simparams.vorst.D )
fprintf('delta x0:  x = %.2f  phi1 = %.0f°  phi2 = %.0f°\n', ...
    delta_x0(1), rad2deg(delta_x0(3)), rad2deg(delta_x0(5)) )

simout = sim('AP_Regelung_Test', Tsim);

results = APAuswertung(simout);
fprintf('Gütemaße:  Jx = %.2f, Jxest = %.2f, Jf = %.0f\n', ...
    results.Jx, results.Jxest, results.Jf )

if results.stabilised
    disp('Um AP stabilisiert')
else
    disp(['AP wurde nicht stabilisiert. Abweichung:'])
    results.xend
end

end