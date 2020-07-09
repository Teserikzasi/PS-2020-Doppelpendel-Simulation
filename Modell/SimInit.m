% Initialisierung der Simulation

% Berechne symbolische DGLs des Schlittenpendels
equations = SchlittenPendelSym();

% Übergebe Motor- und Schlittenpendelparameter
MotorParams = getMotorParam(); 
SchlittenPendelParams = getDPendulumParam_Apprich09();


% Erstelle eine S-Function des nichtlinearen Zustandsraummodells des
% Schlittependels
sys = SchlittenPendelNLZSR(equations, SchlittenPendelParams);
sys2sfct(sys,'SchlittenPendelFunc','M','Path','Modell');

% Anfangswerte
SchlittenPendelParams.x0 = [0 0 0 0 0+eps 0];

% Übergebe Motor- und Schlittenpendelparameter für die Simulation
simparams.gesamtmodell.motor = MotorParams;
Fc0alpha = SchlittenPendelParameter.Fc0alpha;

