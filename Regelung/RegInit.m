% Initialisierung der AP-Regelung

%% Reglerparameter (Q,R)
%riccdata = AP_QR_Chang19();
%riccdata = AP_QR_Ribeiro20();
riccdata = AP_QR_20_neu();

%% Berechnung Daten für alle APs (K,L,linsys)
global APRegDataF
global APRegDataA
APRegDataF = AP_Regelung_init(sysF, Ruhelagen, riccdata);
APRegDataA = AP_Regelung_init(sysA, Ruhelagen, riccdata); 

%% Gleichungen F<->a
equation_a = sysF.f(2); % Gleichung für die Beschleunigung
equation_F = solve(str2sym('a')==equation_a, str2sym('F')); % Gleichung für die Kraft
matlabFunctionBlock('SchlittenGleichungBeschleunigung/x0_pp', equation_a ); % Simulink muss geöffnet sein
matlabFunctionBlock('SchlittenGleichungKraft/F0', equation_F );

%% Simulationsparameter
% Art der Zustandsermittlung
global Zustandsermittlung
Zustandsermittlung = ["Zustandsmessung","Beobachter","Differenzieren"];
simparams.Zustandsermittlung = 2; % Zustandsmessung: 1 , Beobachter: 2 , Differenzieren: 3
% Vorsteuerung
simparams.vorst.C = true;
simparams.vorst.D = true;
simparams.vorst.x0_p_c076 = 0.1;  % 10*realer Wert
simparams.kpv = 150;

%% Arbeitspunkt
testAP = 3;
delta_x0 = [0 0 deg2rad(0) 0 deg2rad(10) 0];

simparams.AP = Ruhelagen(testAP);
simparams.APRegDataA = APRegDataA(testAP);
simparams.APRegDataF = APRegDataF(testAP);
simparams.gesamtmodell.schlittenpendel.x0 = Ruhelagen(testAP).x' + delta_x0;
%[out, results] = SimAP(testAP, delta_x0 );

%%
%plot_outputs(out)
%animate_outputs(out)
%animate_outputs(out,SchlittenPendelParams, 1/4 )
%plotanimate(out)
%plotanimate(out,'AP ?','AP Regelung', SchlittenPendelParams, MotorParams)