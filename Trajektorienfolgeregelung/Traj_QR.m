function [regData, beoData] = Traj_QR()
% Gibt Q und R für Beobachter und Regler der Trajektorienfolgeregelung
% zurück

%% Chang19
regData.Q = diag([1 1 1 1 1 1]);
regData.R = 0.1;

% regData.Q = diag([882 943 949 107 58 164]);
% regData.R = 52.8;

beoData.Q = diag([1 1 1 1 1 1]);
beoData.R = diag([1 1 1])*0.001;

%% Eigene
% neu2
% regData.Q = diag([1, 1, 100, 1, 100, 1]);
% regData.R = 0.01;

% Neu1
% regData.Q = diag([1000, 0.01, 100, 0.1, 100, 0.1]);
% regData.R = 0.001; 

% regData.Q = diag([500, 0.01, 100, 0.1, 100, 0.1]);
% regData.R = 0.01; 

% regData.Q = diag([0.5 1 1 1 1 1]);
% regData.R = 0.1;

end

