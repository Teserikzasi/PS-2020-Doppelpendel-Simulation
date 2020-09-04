function AP_RegData_init(riccdata)
% Initialisiert die Regler Daten für die AP-Regler
% Berechnung Daten für alle APs (K,L,linsys)

global Ruhelagen
global APRegData
global sysF
global sysA

APRegData.F = AP_RegData_calc(sysF, Ruhelagen, riccdata);
APRegData.A = AP_RegData_calc(sysA, Ruhelagen, riccdata); 

end