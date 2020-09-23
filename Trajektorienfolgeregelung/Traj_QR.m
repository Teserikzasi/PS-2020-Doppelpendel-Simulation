function [regData, beoData] = Traj_QR()
% Gibt Q und R für Beobachter und Regler der Trajektorienfolgeregelung
% zurück

% Dummies (aus Chang19)
regData.Q = diag([1 1 1 1 1 1]);
regData.R = 0.1;
beoData.Q = diag([1 1 1 1 1 1]);
beoData.R = diag([1 1 1])*0.001;

end

