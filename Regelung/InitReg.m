% Initialisierung der AP-Regelung

InitVorstBeob_Fa()  % Gleichungen F<->a

global APRegData  
%InitAPRegData(AP_QR_Chang19())
%InitAPRegData(AP_QR_Ribeiro20())
InitAPRegData(AP_QR_20_neu())

InitSimReg

% Simulation Arbeitspunkt
testAP = 3;
delta_x0 = [0 0 deg2rad(5) 0 deg2rad(10) 0];
%SimAP_run
