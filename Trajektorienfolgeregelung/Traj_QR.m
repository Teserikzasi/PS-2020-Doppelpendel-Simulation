function [regData, beoData] = Traj_QR()
% Gibt Q und R für Beobachter und Regler der Trajektorienfolgeregelung
% zurück

%% Chang19
% regData.Q = diag([1 1 1 1 1 1]);
% regData.R = 0.1;

beoData.Q = diag([1 1 1 1 1 1]);
beoData.R = diag([1 1 1])*0.001;

%% Eigene
% regData.Q = diag([10, 1, 10, 1, 10, 1]);
% regData.R = 0.1;

regData.Q = diag([1000, 0.01, 100, 0.1, 100, 0.1]);
regData.R = 0.001; 

end

