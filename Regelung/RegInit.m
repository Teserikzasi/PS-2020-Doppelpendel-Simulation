% Initialisierung der AP-Regelung

%% Gleichungen F<->a
InitVorstBeob_Fa(sysF)

%% Regler Initialisierung
global APRegData
%InitAPRegData(AP_QR_Chang19());
%InitAPRegData(AP_QR_Ribeiro20());
InitAPRegData(AP_QR_20_neu());

%% Simulationsparameter
global Zustandsermittlung % Art der Zustandsermittlung
Zustandsermittlung = ["Zustandsmessung","Beobachter","Differenzieren"];
simparams.Zustandsermittlung = 1; % Zustandsmessung: 1 , Beobachter: 2 , Differenzieren: 3
% Vorsteuerung
% simparams.vorst.C = true;
% simparams.vorst.D = true;
% simparams.vorst.x0_p_c076 = 0.1;  % 10*realer Wert
simparams.kpv = 150;

%% Simulation Arbeitspunkt
testAP = 3;
delta_x0 = [0 0 deg2rad(0) 0 deg2rad(10) 0];
%[out, results] = SimAP(testAP, delta_x0 );
