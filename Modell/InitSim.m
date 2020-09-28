
% Übergebe Motor- und Schlittenpendelparameter für die Simulation

global simparams
simparams.tows_ts = 1/100;  % fps für x,phi1,phi2 für Animation
simparams.gesamtmodell.motor = MotorParams;
simparams.gesamtmodell.schlittenpendel = SchlittenPendelParams;
simparams.gesamtmodell.schlittenpendel.x0 = [0 0 0 0 1e-2 0];  % Anfangswerte