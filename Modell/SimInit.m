% Initialisierung der Simulation

% Berechne symbolische DGLs des Schlittenpendels
equations = SchlittenPendelSym();
Ruhelagen = SchlittenPendelRuhelagen();

% Übergebe Motor- und Schlittenpendelparameter
MotorParams = MotorParams_Franke97();
SchlittenPendelParams = SchlittenPendelParams_Apprich09();
%SchlittenPendelParams = SchlittenPendelParams_Chang19();
%SchlittenPendelParams = SchlittenPendelParams_Ribeiro20();


% Erstelle eine S-Function des nichtlinearen Zustandsraummodells des Schlittependels
sys = SchlittenPendelNLZSR(equations, SchlittenPendelParams);
sys2sfct(sys,'SchlittenPendelFunc','M','Path','Modell');

% Anfangswerte
SchlittenPendelParams.x0 = Ruhelagen(4).x' + [0 0 0 0 1e-2 0];

% Übergebe Motor- und Schlittenpendelparameter für die Simulation
simparams.tows_ts = 1/30;
simparams.gesamtmodell.motor = MotorParams;
simparams.gesamtmodell.schlittenpendel = SchlittenPendelParams;
