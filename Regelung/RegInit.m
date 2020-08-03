
riccdata = AP_QR_Chang19();
%riccdata = AP_QR_Ribeiro20();

APRegData = AP_Regelung_init(sys, Ruhelagen, riccdata);

TestAP = 1;
delta_x0 = [0 0 1 0 -0.4 0];

simparams.AP = Ruhelagen(TestAP);
simparams.APRegData = APRegData(TestAP);
simparams.gesamtmodell.schlittenpendel.x0 = Ruhelagen(TestAP).x' + delta_x0;
simparams.MotorGain = MotorParams.staticGain;

%plot_outputs(out)
%plot_outputs(out,true,'AP1 ?','Plots\AP Regelung')
%animate_outputs(out)
%animate_outputs(out,SchlittenPendelParams,true,'AP1 ?','Plots\AP Regelung')