% Initialisierung der Simulation
clear global

%% Berechne symbolische DGL des Schlittenpendels
global equationsF % zum Überschreiben bei simTraj_FauveODE
equationsF = SchlittenPendelSymF();
equationsA = SchlittenPendelSymA();
global Ruhelagen
Ruhelagen = SchlittenPendelRuhelagen();

%% Motor- und Schlittenpendelparameter
global MotorParams
global SchlittenPendelParams
MotorParams = MotorParams_Franke97();
SchlittenPendelParams = SchlittenPendelParams_Apprich09();
%SchlittenPendelParams = SchlittenPendelParams_Chang19();
%SchlittenPendelParams = SchlittenPendelParams_Ribeiro20();
%SchlittenPendelParams.Fc0 = 0; % Coulomb-Reibung deaktivieren

%% Erstelle nichtlineares parametrisiertes Zustandsraummodell und S-Function
global sysF % zum Überschreiben bei simTraj_FauveODE
global sysA
sysF = SchlittenPendelNLZSR(equationsF, SchlittenPendelParams, 'F');
sysA = SchlittenPendelNLZSR(equationsA, SchlittenPendelParams, 'a');
sys2sfct(sysF,'SchlittenPendelFunc','M','Path','Modell');

%% Übergebe Motor- und Schlittenpendelparameter für die Simulation
global simparams
simparams.tows_ts = 1/50;  % fps für x,phi1,phi2 für Animation
simparams.gesamtmodell.motor = MotorParams;
simparams.gesamtmodell.schlittenpendel = SchlittenPendelParams;
simparams.gesamtmodell.schlittenpendel.x0 = [0 0 0 0 1e-2 0];  % Anfangswerte

%% Auswertung
%plot_outputs(out)
%animate_outputs(out)
%animate_outputs(out, 1/4 )
%plotanimate(out)
%plotanimate(out,'AP ?','Modell Tests' )