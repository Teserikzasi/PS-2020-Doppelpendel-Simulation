
%MotorParams = MotorParams_Franke97();
SchlittenPendelParams = SchlittenPendelParams_Ribeiro20();
vari = 's1';
range = linspace(0.0000,2*SchlittenPendelParams.(vari),9);

respv = SysParameter_Variation(SchlittenPendelParams, vari, range, 1);

% resMc10 = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'Mc10', linspace(0,2*SchlittenPendelParams_Ribeiro20().Mc10,11), 1);
% resMc20 = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'Mc20', linspace(0,4*SchlittenPendelParams_Ribeiro20().Mc20,9), 2);
% resMc10Beob = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'Mc10', linspace(0,2*SchlittenPendelParams_Ribeiro20().Mc10,11), 1, 2, AP_QR_20_neu_Beob());
% resMc20Beob = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'Mc20', linspace(0,4*SchlittenPendelParams_Ribeiro20().Mc20,9), 2, 2, AP_QR_20_neu_Beob());

% resm0 = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'm0', linspace(0.001,2*SchlittenPendelParams_Ribeiro20().m0,9));
% resm1 = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'm1', 0:0.2:2);
% resm2 = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'm2', [0.01 0.1:0.1:1]);

% resJ1 = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'J1', linspace(0.000,2*SchlittenPendelParams_Ribeiro20().J1,9));
% resJ2 = SysParameter_Variation(SchlittenPendelParams_Ribeiro20(), 'J2', linspace(0.000,2*SchlittenPendelParams_Ribeiro20().J2,9));


% plot_x0_APs(res, range, vari )

% hold on
% plot([SchlittenPendelParams_Ribeiro20().(vari) SchlittenPendelParams_Ribeiro20().(vari)], ylim, 'k--')
% plot(SchlittenPendelParams_Ribeiro20().(vari), 18, 'k.')


% kein Einfluss: Fc0, d0, d2, Mc20
% geringer Einfluss: d1