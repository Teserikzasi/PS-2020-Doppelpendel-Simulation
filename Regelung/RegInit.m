
riccdata = AP_QR_Chang19();
%riccdata = AP_QR_Ribeiro20();

APRegDataA = AP_Regelung_init(sysA, Ruhelagen, riccdata);
APRegDataF = AP_Regelung_init(sysF, Ruhelagen, riccdata);

TestAP = 1;
delta_x0 = [-2 0 0.2 0 -0.4 0];

simparams.AP = Ruhelagen(TestAP);
simparams.APRegDataA = APRegDataA(TestAP);
simparams.APRegDataF = APRegDataF(TestAP);
simparams.gesamtmodell.schlittenpendel.x0 = Ruhelagen(TestAP).x' + delta_x0;
simparams.MotorGain = MotorParams.staticGain;
simparams.vorst.C = false;
simparams.vorst.D = false;
% Art der Zustandsermittlung
% Zustandsmessung: 0 , Beobachter: 1 , Differenzieren: 2
simparams.Zustandsermittlung = 0;

%plotanimate(out)
%plotanimate(out,'AP1 ?','AP Regelung')
%SchlittenPendelParams