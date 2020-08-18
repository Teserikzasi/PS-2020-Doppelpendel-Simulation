
riccdata = AP_QR_Chang19();
%riccdata = AP_QR_Ribeiro20();

% Daten für AP-Regelung: K, regPolo, L, beobPole, syslin, kpv, riccdata=Q,R
APRegDataA = AP_Regelung_init(sysA, Ruhelagen, riccdata);
APRegDataF = AP_Regelung_init(sysF, Ruhelagen, riccdata);

testAP = 2;
delta_x0 = [0 0 0 0 0.1 0];


simparams.AP = Ruhelagen(testAP);
simparams.APRegDataA = APRegDataA(testAP);
simparams.APRegDataF = APRegDataF(testAP);
simparams.gesamtmodell.schlittenpendel.x0 = Ruhelagen(testAP).x' + delta_x0;
simparams.vorst.C = false;
simparams.vorst.D = false;
% Art der Zustandsermittlung
% Zustandsmessung: 0 , Beobachter: 1 , Differenzieren: 2
simparams.Zustandsermittlung = 1;


%plot_outputs(out)
%animate_outputs(out)
%animate_outputs(out,SchlittenPendelParams, 1/4 )
%plotanimate(out)
%plotanimate(out,'AP ?','AP Regelung', SchlittenPendelParams, MotorParams)