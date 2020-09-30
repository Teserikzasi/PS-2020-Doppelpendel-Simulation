
simparams.Zustandsermittlung = 1;  % ZM

tic
InitAPRegData(AP_QR_Chang19())
resC = x0_Test_APs();
InitAPRegData(AP_QR_Ribeiro20())
resR = x0_Test_APs();
InitAPRegData(AP_QR_20_neu())
resN = x0_Test_APs();
toc

plot_x0_APs([resC resR resN], ["Chang19","Ribeiro20","20neu"] )