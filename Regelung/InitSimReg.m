
% Initialisiert Simulationsparameter

global Zustandsermittlung % Art der Zustandsermittlung
Zustandsermittlung = ["Zustandsmessung","Beobachter","Differenzieren"];
simparams.Zustandsermittlung = 1; % Zustandsmessung: 1 , Beobachter: 2 , Differenzieren: 3

simparams.regler.gesamtmodell.motor = MotorParamsReg;
simparams.regler.gesamtmodell.schlittenpendel = SchlittenPendelParamsReg;

% Vorsteuerung MCD
simparams.regler.vorst.C = 0.95;
simparams.regler.vorst.D = 0.95;
simparams.regler.vorst.x0_p_c076 = 10*SchlittenPendelParams.x0_p_c076;

simparams.regler.kpv = 150;
