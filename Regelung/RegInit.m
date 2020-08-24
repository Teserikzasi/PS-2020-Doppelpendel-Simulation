
riccdata = AP_QR_Chang19();
%riccdata = AP_QR_Ribeiro20();

% Daten für AP-Regelung: K, regPolo, L, beobPole, syslin, kpv, riccdata=Q,R
APRegDataA = AP_Regelung_init(sysA, Ruhelagen, riccdata);
APRegDataF = AP_Regelung_init(sysF, Ruhelagen, riccdata);

matlabFunctionBlock('Schlitten_Beschleunigung/x0_pp', sysF.f(2) ); % Gleichung für die Beschleunigung

testAP = 2;
delta_x0 = [0 0 0 0 0.1 0];


simparams.AP = Ruhelagen(testAP);
simparams.APRegDataA = APRegDataA(testAP);
simparams.APRegDataF = APRegDataF(testAP);
simparams.gesamtmodell.schlittenpendel.x0 = Ruhelagen(testAP).x' + delta_x0;
simparams.vorst.C = true;
simparams.vorst.D = true;
simparams.vorst.x0_p_c2 = 0.1;  % 10*x0_p_c2
% Art der Zustandsermittlung
% Zustandsmessung: 0 , Beobachter: 1 , Differenzieren: 2
simparams.Zustandsermittlung = 1;


%plot_outputs(out)
%animate_outputs(out)
%animate_outputs(out,SchlittenPendelParams, 1/4 )
%plotanimate(out)
%plotanimate(out,'AP ?','AP Regelung', SchlittenPendelParams, MotorParams)