% Initialisierung der AP-Regelung

%% Reglerparameter berechnen
global APRegData
%AP_RegData_init(AP_QR_Chang19());
%AP_RegData_init(AP_QR_Ribeiro20());
AP_RegData_init(AP_QR_20_neu());

%% Gleichungen F<->a
equation_a = sysF.f(2); % Gleichung für die Beschleunigung
equation_F = solve(str2sym('a')==equation_a, str2sym('F')); % Gleichung für die Kraft
matlabFunctionBlock('SchlittenGleichungBeschleunigung/x0_pp', equation_a ); % Simulink muss geöffnet sein
matlabFunctionBlock('SchlittenGleichungKraft/F0', equation_F );

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

%% Auswertung
%plot_outputs(out)
%animate_outputs(out)
%animate_outputs(out, 1/4 )
%plotanimate(out)
%plotanimate(out,'AP ?','AP Regelung' )