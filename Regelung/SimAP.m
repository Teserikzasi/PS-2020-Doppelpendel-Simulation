function [simout,results] = SimAP(simparams)
% Simuliert eine AP-Regelung

Tsim = 15;

disp(['Simuliere AP-Regelung (AP ' int2str(simparams.AP.i) ')' ])
simout = sim('AP_Regelung_Test', Tsim);
results = APAuswertung(simout)
%results.xend_norm

if results.stabilised
    disp('Um AP stabilisiert')
else
    disp(['AP wurde nicht stabilisiert. Abweichung:'])
    results.xend
end

plotanimate(simout)

end