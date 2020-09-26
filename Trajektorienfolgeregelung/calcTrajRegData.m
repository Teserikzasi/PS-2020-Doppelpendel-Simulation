% PROTOTYP
function regData = calcTrajRegData(sys, stTraj, regData, beoData)
% Linearisiert um Trajektorie des nichtlinearen Systems und 
% berechnet Regler und Beobachter für gegebene Werte

syslin = linSys(sys);

regData.K.data = getTrajFBController_LQR(syslin, stTraj, regData.Q, regData.R);
regData.K.data = squeeze(regData.K.data);

[regData.L.data, regData.A.data, regData.B.data] = getTrajFBObserver_LQR(syslin, stTraj, beoData.Q, beoData.R);

						
end
