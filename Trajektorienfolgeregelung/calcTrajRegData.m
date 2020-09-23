% PROTOTYP
function stTraj = calcTrajRegData(sys, stTraj, regData, beoData)
% Linearisiert um Trajektorie des nichtlinearen Systems und 
% berechnet Regler und Beobachter für gegebene Werte

syslin = linSys(sys);

stTraj.K = getTrajFBController_LQR(syslin, stTraj, regData.Q, regData.R);

[stTraj.L.data, stTraj.A.data, stTraj.B.data] = getTrajFBObserver_LQR(syslin, stTraj, beoData.Q, beoData.R);

						
end
