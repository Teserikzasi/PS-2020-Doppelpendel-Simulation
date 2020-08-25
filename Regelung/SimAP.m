function [simout, results] = SimAP(testAP, delta_x0, Tsim)
% Simuliert eine AP-Regelung mit gegebenem AP und x0

if ~exist('Tsim', 'var')
    Tsim = 10;
end

global simparams;
global APRegDataA;
global APRegDataF;
global Ruhelagen;
simparams.AP = Ruhelagen(testAP);
simparams.APRegDataA = APRegDataA(testAP);
simparams.APRegDataF = APRegDataF(testAP);
simparams.gesamtmodell.schlittenpendel.x0 = Ruhelagen(testAP).x' + delta_x0;

disp(['Simuliere AP-Regelung (AP ' int2str(simparams.AP.i) ') ...' ])
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