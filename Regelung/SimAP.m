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

if any(out.MotorSatState.Data)
    disp("Motor in Sättigung!")
end

plotanimate(out)

%end