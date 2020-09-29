
% Erstellt nichtlineares parametrisiertes Zustandsraummodell und S-Function

global sysF
global sysA
sysF = SchlittenPendelNLZSR(equationsF, SchlittenPendelParams, 'F');
sysA = SchlittenPendelNLZSR(equationsA, SchlittenPendelParams, 'a');

fprintf('System parametrisiert mit: %s\n', SchlittenPendelParams.name)

sys2sfct(sysF,'SchlittenPendelFunc','M','Path','Modell');