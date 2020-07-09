% Initialisierung der Simulation

% Berechne symbolische DGLs des Schlittenpendels
equations = SchlittenPendelSym()

% Übergebe Motor- und Schlittenpendelparameter
MotorParams = getMotorParam_Franke97(); 
SchlittenPendelParams = getDPendulumParam_Apprich09();


% Erstelle eine S-Function des nichtlinearen Zustandsraummodells des
% Schlittependels
sys = SchlittenPendelNLZSR(equations,SchlittenPendelParams);
sys2sfct(sys,'SchlittenPendelFunc','M','Path','Modell');

% --- paste your comment here ---
SchlittenPendelParams.x0 = [0 0 0 0 0+eps 0];

% Übergebe Motor- und Schlittenpendelparameter für die Simulation
simparams.gesamtmodell.motor=MotorParams;
simparams.gesamtmodell.schlittenpendel=SchlittenPendelParams;