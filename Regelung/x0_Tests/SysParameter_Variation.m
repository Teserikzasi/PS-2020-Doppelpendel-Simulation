function res = SysParameter_Variation(SchlittenPendelParams, vari, range, stepdeg, zsterm, riccdata)
% Variiert einen System-Parameter in dem angegebenen Bereich und wertet die x0 Tests aus
% vari: Parameter von SchlittenPendelParams (z.B. 'm1')
% range: Testbereich für den Parameter
% stepdeg: Schrittweite für x0 Test in ° (optional)
% zsterm: Zustandsermittlung (optional)
% riccdata: QR-Parameter (optional)

if ~exist('stepdeg', 'var')
    stepdeg=1;
end

if ~exist('zsterm', 'var')
    zsterm=1;
end

if ~exist('riccdata', 'var')
    riccdata = AP_QR_20_neu();
end

global sysRegF

i=1;
tic
for P=range
    fprintf('%s = %f\n', vari, P)
    SchlittenPendelParams.(vari) = P;
    
    InitSystem(SchlittenPendelParams)  % Parametrisierung
    %InitSim  % Initialisiert Simulation (in Abh von MotorParams)
    InitSystemReg()
    InitVorstBeob_Fa(sysRegF)
    InitAPRegData(riccdata)
    InitSimReg(zsterm)

    res(i) = x0_Test_APs(stepdeg);
    i=i+1;
end
toc

plot_x0_APs(res, range, vari )

end