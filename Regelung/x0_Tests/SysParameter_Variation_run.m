

simparams.Zustandsermittlung = 1;  % ZM
%MotorParams = MotorParams_Franke97();
SchlittenPendelParams = SchlittenPendelParams_Ribeiro20();
vari = 'l1';
range = linspace(0.0001,2*SchlittenPendelParams.(vari),7); %0.2:0.2:2;

respv = SysParameter_Variation(SchlittenPendelParams, vari, range, 2);

% respvMc10 = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'Mc10', linspace(0,2*SchlittenPendelParams_Ribeiro20().Mc10,11), 1);
% respvMc20 = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'Mc20', linspace(0,4*SchlittenPendelParams_Ribeiro20().Mc20,9), 2);
% respvMc10Beob = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'Mc10', linspace(0,2*SchlittenPendelParams_Ribeiro20().Mc10,11), 1, 2, AP_QR_20_neu_Beob());
% respvMc20Beob = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'Mc20', linspace(0,4*SchlittenPendelParams_Ribeiro20().Mc20,9), 2, 2, AP_QR_20_neu_Beob());


% plot_x0_APs(res, range, vari )


% kein Einfluss: Fc0, d0, d2, Mc20
% geringer Einfluss: d1