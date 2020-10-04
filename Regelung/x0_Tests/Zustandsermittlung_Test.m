
InitAPRegData(AP_QR_20_neu())

tic
simparams.Zustandsermittlung = 1;  % ZM
resM = x0_Test_APs();
simparams.Zustandsermittlung = 2;  % Beob
resB = x0_Test_APs();
% simparams.Zustandsermittlung = 3;  % Diff
% resD = x0_Test_APs();
toc

plot_x0_APs( [resM resB ], Zustandsermittlung(1:2) )