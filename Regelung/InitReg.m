% Initialisierung der AP-Regelung

InitSystemReg  % Modell für den Regler

InitVorstBeob_Fa(sysRegF)  % Gleichungen F<->a

global APRegData  
%InitAPRegData(AP_QR_Chang19())
%InitAPRegData(AP_QR_Ribeiro20())
InitAPRegData(AP_QR_20_neu())  % in Abh von sysReg

InitSimReg  % Initialisiert Simulation

% Simulation Arbeitspunkt
testAP = 3;
delta_x0 = [0 0 deg2rad(5) 0 deg2rad(10) 0];
%SimAP_run
