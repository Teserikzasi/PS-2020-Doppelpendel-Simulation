
% Initialisiere Simulationsparameter

global Zustandsermittlung % Art der Zustandsermittlung
Zustandsermittlung = ["Zustandsmessung","Beobachter","Differenzieren"];
simparams.Zustandsermittlung = 1; % Zustandsmessung: 1 , Beobachter: 2 , Differenzieren: 3

% Vorsteuerung MCD
simparams.vorst.C = true;
simparams.vorst.D = true;
simparams.vorst.x0_p_c076 = 0.1;  % 10*realer Wert

simparams.kpv = 150;