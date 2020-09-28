
% Motor- und SchlittenPendel-Parameter festlegen

global MotorParams
global SchlittenPendelParams

MotorParams = MotorParams_Franke97();

%SchlittenPendelParams = SchlittenPendelParams_Apprich09();
%SchlittenPendelParams = SchlittenPendelParams_Chang19();
SchlittenPendelParams = SchlittenPendelParams_Ribeiro20();

%SchlittenPendelParams.Fc0 = 0; % Coulomb-Reibung deaktivieren
%SchlittenPendelParams.Mc10 = 0;
%SchlittenPendelParams.Mc20 = 0;