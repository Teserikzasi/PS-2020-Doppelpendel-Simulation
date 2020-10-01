
simparams.Zustandsermittlung = 1;  % ZM
range = 0.2:0.2:2;
vari = 'm2';

%MotorParams = MotorParams_Franke97();
SchlittenPendelParams = SchlittenPendelParams_Ribeiro20();

i=1;
for P=range
    fprintf('%s = %f\n', vari, P)
    SchlittenPendelParams.(vari) = P;
    
    InitSystem(SchlittenPendelParams)  % Parametrisierung
    %InitSim  % Initialisiert Simulation (in Abh von MotorParams)
    InitSystemReg
    InitVorstBeob_Fa(sysRegF)
    InitAPRegData(AP_QR_20_neu())
    InitSimReg

    res(i) = x0_Test_APs();
    i=i+1;
end

plot_x0_APs(res, range, vari )

