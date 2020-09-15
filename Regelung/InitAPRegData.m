function InitAPRegData(riccdata)
% Initialisiert die Regler Daten (K,L,linsys) für alle APs

global Ruhelagen
global APRegData
global sysF
global sysA

APRegData.F = CalcAPRegData(sysF, Ruhelagen, riccdata);
APRegData.A = CalcAPRegData(sysA, Ruhelagen, riccdata);

fprintf('AP-Regler initialisiert für QR-Werte von %s\n', riccdata(1).name)

end