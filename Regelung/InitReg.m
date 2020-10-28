% Initialisierung der AP-Regelung

global MotorParamsReg
global SchlittenPendelParamsReg
global sysRegF
global sysRegA
InitSystemReg()  % Modell für den Regler

InitVorstBeob_Fa(sysRegF)  % Gleichungen F<->a

global APRegData  
%InitAPRegData(AP_QR_Chang19())
%InitAPRegData(AP_QR_Ribeiro20())
InitAPRegData(AP_QR_20_neu())  % in Abh von sysReg

global Zustandsermittlung % Art der Zustandsermittlung
Zustandsermittlung = ["Zustandsmessung","Beobachter","Differenzieren"];
InitSimReg()  % Initialisiert Simulation


%SimAP_run
