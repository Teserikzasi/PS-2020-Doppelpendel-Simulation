% Initialisierung der Simulation

InitSymEq  % Symbolische Systemgleichungen

global MotorParams
global SchlittenPendelParams
MotorParams = MotorParams_Franke97();
SchlittenPendelParams = SchlittenPendelParams_Apprich09();
%SchlittenPendelParams = SchlittenPendelParams_Chang19();
%SchlittenPendelParams = SchlittenPendelParams_Ribeiro20();
%SchlittenPendelParams.Fc0 = 0; % Coulomb-Reibung deaktivieren
%SchlittenPendelParams.Mc10 = 0;
%SchlittenPendelParams.Mc20 = 0;

InitSystem  % in Abh von SchlittenPendelParams

InitSim  % Initialisiere simparams


% Auswertung
%plot_outputs(out)
%animate_outputs(out)
%animate_outputs(out, 1/4 )
%plotanimate(out)
%plotanimate(out,'AP ?','Modell Tests' )