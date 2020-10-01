% Initialisierung

InitSymEq  % Symbolische Systemgleichungen

InitParams  % Parameter einlesen

global sysF
global sysA
InitSystem(SchlittenPendelParams)  % Parametrisierung

InitSim  % Initialisiert Simulation (in Abh von MotorParams)


% Auswertung
%plot_outputs(out)
%animate_outputs(out)
%animate_outputs(out, 1/4 )
%plotanimate(out)
%plotanimate(out,'AP ?','Modell Tests' )