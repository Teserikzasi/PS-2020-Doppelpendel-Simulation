
tic

InitAPRegData(AP_QR_20_neu())
simparams.Zustandsermittlung = 1;  % ZM
resM = x0_Test_APs();
simparams.Zustandsermittlung = 2;  % Beob
resB = x0_Test_APs();
% simparams.Zustandsermittlung = 3;  % Diff
% resD = x0_Test_APs();

InitAPRegData(AP_QR_20_neu_Beob())
simparams.Zustandsermittlung = 2;
resBN = x0_Test_APs();

toc

plot_x0_APs( [resM resB resBN ], ["ZM","Beob","Beob (neu)"] )