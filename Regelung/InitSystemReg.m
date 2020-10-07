function InitSystemReg(coulombdeak, param_unsicherheit)
% Erstellt das Modell für den Regler, in Abhängigkeit der echten Parameter

global MotorParams
global SchlittenPendelParams
global MotorParamsReg
global SchlittenPendelParamsReg
MotorParamsReg = MotorParams;
SchlittenPendelParamsReg = SchlittenPendelParams;

if ~exist('coulombdeak', 'var') || coulombdeak==true
    %SchlittenPendelParamsReg.Fc0 = 0;
    SchlittenPendelParamsReg.Mc10 = 0; % Coulomb-Reibung wg Linearisierung deaktivieren
    SchlittenPendelParamsReg.Mc20 = 0;
end

global equationsF
global equationsA
global sysRegF
global sysRegA
sysRegF = SchlittenPendelNLZSR(equationsF, SchlittenPendelParamsReg, 'F');
sysRegA = SchlittenPendelNLZSR(equationsA, SchlittenPendelParamsReg, 'a');

end