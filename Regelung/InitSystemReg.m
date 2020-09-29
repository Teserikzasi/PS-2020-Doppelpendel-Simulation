
% Erstellt das Modell für den Regler, in Abhängigkeit der echten Parameter

MotorParamsReg = MotorParams;

SchlittenPendelParamsReg = SchlittenPendelParams;
%SchlittenPendelParamsReg.Fc0 = 0;
SchlittenPendelParamsReg.Mc10 = 0; % Coulomb-Reibung wg Linearisierung deaktivieren
SchlittenPendelParamsReg.Mc20 = 0;

global sysRegF
global sysRegA
sysRegF = SchlittenPendelNLZSR(equationsF, SchlittenPendelParamsReg, 'F');
sysRegA = SchlittenPendelNLZSR(equationsA, SchlittenPendelParamsReg, 'a');