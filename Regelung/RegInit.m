
riccdata = AP_QR_Chang19();
%riccdata = AP_QR_Ribeiro20();

APRegData = AP_Regelung_init(sys, Ruhelagen, riccdata);

simparams.Ruhelagen = Ruhelagen;
simparams.APRegData = APRegData;
simparams.gesamtmodell.schlittenpendel.x0 = Ruhelagen(1).x' + [0 0 0 0 0.1 0];