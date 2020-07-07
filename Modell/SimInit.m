% Initialisierung der Simulation

% Berechne symbolische DGLs des Schlittenpendels
equations = SchlittenPendelSym()

% Übergebe Motor- und Schlittenpendelparameter
MotorParams = getMotorParam(); 
SchlittenPendelParams = getDPendulumParam_Apprich09();


% Erstelle eine S-Function des nichtlinearen Zustandsraummodells des
% Schlittependels
sys = SchlittenPendelNLZSR(equations,SchlittenPendelParams);
sys2sfct(sys,'SchlittenPendelFunc','M');

% --- paste your comment here ---
SchlittenPendelParams.x0 = [0 0 pi 0 0.1 0];

% Übergebe Motor- und Schlittenpendelparameter für die Simulation
simparams.gesamtmodell.motor=MotorParams;
simparams.gesamtmodell.schlittenpendel=SchlittenPendelParams;