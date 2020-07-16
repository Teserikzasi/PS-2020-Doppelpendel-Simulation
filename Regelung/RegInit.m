
riccdata = AP_QR_Chang19();
%riccdata = AP_QR_Ribeiro20();
beobPole = 1:6;

RegData = AP_Regelung_init(sys, Ruhelagen, riccdata, beobPole);