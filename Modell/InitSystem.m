function InitSystem(SchlittenPendelParamsArg)
% Erstellt nichtlineares parametrisiertes Zustandsraummodell und S-Function
% in Abhängigkeit von SchlittenPendelParams

global SchlittenPendelParams
SchlittenPendelParams = SchlittenPendelParamsArg;

global equationsF
global equationsA
global sysF
global sysA
sysF = SchlittenPendelNLZSR(equationsF, SchlittenPendelParams, 'F');
sysA = SchlittenPendelNLZSR(equationsA, SchlittenPendelParams, 'a');
fprintf('System parametrisiert mit: %s\n', SchlittenPendelParams.desc)

sys2sfct(sysF,'SchlittenPendelFunc','M','Path','Modell');

end