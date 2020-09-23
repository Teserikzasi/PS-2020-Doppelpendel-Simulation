function [dev_x0, dev_AP_phi1, dev_AP_phi2] = getInitDev()
% Gibt die Variationen der Anfangsauslenkung für die Trajektoriensuche
% zurück
dev_x0 = [0.5 0.3 0.1 0];
dev_AP_phi1 = [pi -pi  pi -pi -pi pi 0   0];   
dev_AP_phi2 = [pi  pi -pi -pi  0  0 -pi  pi]; 

end

