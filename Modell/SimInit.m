% Initialisierung der Simulation

% Berechne symbolische DGLs des Schlittenpendels
equationsF = SchlittenPendelSymF();
equationsA = SchlittenPendelSymA();
global Ruhelagen
Ruhelagen = SchlittenPendelRuhelagen();

% Übergebe Motor- und Schlittenpendelparameter
MotorParams = MotorParams_Franke97();
SchlittenPendelParams = SchlittenPendelParams_Apprich09();
%SchlittenPendelParams = SchlittenPendelParams_Chang19();
%SchlittenPendelParams = SchlittenPendelParams_Ribeiro20();


% Erstelle eine S-Function des nichtlinearen Zustandsraummodells des Schlittependels
sysF = SchlittenPendelNLZSR(equationsF, SchlittenPendelParams, 'F');
sysA = SchlittenPendelNLZSR(equationsA, SchlittenPendelParams, 'a');
sys2sfct(sysF,'SchlittenPendelFunc','M','Path','Modell');

% Anfangswerte
SchlittenPendelParams.x0 = Ruhelagen(4).x' + [0 0 0 0 1e-2 0];

% Übergebe Motor- und Schlittenpendelparameter für die Simulation
global simparams
simparams.gesamtmodell.motor = MotorParams;
simparams.gesamtmodell.schlittenpendel = SchlittenPendelParams;
simparams.tows_ts = 1/30;


%plot_outputs(out)
%animate_outputs(out)
%animate_outputs(out,SchlittenPendelParams, 1/4 )
%plotanimate(out)
%plotanimate(out,'AP ?','Modell Tests', SchlittenPendelParams, MotorParams)