
riccdata = AP_QR_Chang19();
%riccdata = AP_QR_Ribeiro20();

% Daten für AP-Regelung: K, regPole, L, beobPole, syslin, kpv, riccdata=Q,R
global APRegDataA
global APRegDataF
APRegDataA = AP_Regelung_init(sysA, Ruhelagen, riccdata);
APRegDataF = AP_Regelung_init(sysF, Ruhelagen, riccdata);

matlabFunctionBlock('Schlitten_Beschleunigung/x0_pp', sysF.f(2) ); % Gleichung für die Beschleunigung. Simulink muss geöffnet sein

% Art der Zustandsermittlung
Zustandsermittlung = ["Zustandsmessung","Beobachter","Differenzieren"];
simparams.Zustandsermittlung = 1; % Zustandsmessung: 1 , Beobachter: 2 , Differenzieren: 3
% Vorsteuerung
simparams.vorst.C = true;
simparams.vorst.D = true;
simparams.vorst.x0_p_c2 = 0.1;  % 10*x0_p_c2

testAP = 3;
delta_x0 = [0 0 0 0 0.2 0];

simparams.AP = Ruhelagen(testAP);
simparams.APRegDataA = APRegDataA(testAP);
simparams.APRegDataF = APRegDataF(testAP);
simparams.gesamtmodell.schlittenpendel.x0 = Ruhelagen(testAP).x' + delta_x0;
%[out, results] = SimAP(testAP, delta_x0 );

%plot_outputs(out)
%animate_outputs(out)
%animate_outputs(out,SchlittenPendelParams, 1/4 )
%plotanimate(out)
%plotanimate(out,'AP ?','AP Regelung', SchlittenPendelParams, MotorParams)