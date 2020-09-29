function InitAPRegData(riccdata)
% Initialisiert die Regler Daten (K,L,linsys) für alle APs
% anhand des Modells für den Regler (sysReg)

global Ruhelagen
global APRegData
global sysRegF
global sysRegA

APRegData.F = CalcAPRegData(sysRegF, Ruhelagen, riccdata);
APRegData.A = CalcAPRegData(sysRegA, Ruhelagen, riccdata);

fprintf('AP-Regler initialisiert für QR-Werte von: %s\n', riccdata(1).name)

end