
% Erstelle nichtlineares parametrisiertes Zustandsraummodell und S-Function

global sysF  % wird für die Reglerberechnung benötigt
global sysA
sysF = SchlittenPendelNLZSR(equationsF, SchlittenPendelParams, 'F');
sysA = SchlittenPendelNLZSR(equationsA, SchlittenPendelParams, 'a');

sys2sfct(sysF,'SchlittenPendelFunc','M','Path','Modell');