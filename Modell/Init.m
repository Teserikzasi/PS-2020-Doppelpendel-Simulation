% Initialisierung

InitSymEq  % Symbolische Systemgleichungen

InitParams  % Parameter einlesen

global sysF
global sysA
InitSystem(SchlittenPendelParams)  % Parametrisierung

InitSim  % Initialisiert Simulation (in Abh von MotorParams)
