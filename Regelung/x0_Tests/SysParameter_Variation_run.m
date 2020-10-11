

simparams.Zustandsermittlung = 1;  % ZM
%MotorParams = MotorParams_Franke97();
SchlittenPendelParams = SchlittenPendelParams_Ribeiro20();
vari = 's1';
range = linspace(0.00,2*SchlittenPendelParams.(vari),7); %0.2:0.2:2;

respv = SysParameter_Variation(SchlittenPendelParams, vari, range, 2);

% kein Einfluss: Fc0, d0, d2, Mc20
% geringer Einfluss: d1