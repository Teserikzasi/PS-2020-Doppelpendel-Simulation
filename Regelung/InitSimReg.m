function InitSimReg(ZustandsermittlungArg, kpv)
% Initialisiert Simulationsparameter

global MotorParamsReg
global SchlittenPendelParamsReg
global simparams
global Zustandsermittlung

simparams.regler.gesamtmodell.motor = MotorParamsReg;
simparams.regler.gesamtmodell.schlittenpendel = SchlittenPendelParamsReg;

% Zustandsmessung: 1 , Beobachter: 2 , Differenzieren: 3
if ~exist('ZustandsermittlungArg', 'var')
    ZustandsermittlungArg = 1;
end
simparams.Zustandsermittlung = ZustandsermittlungArg;
fprintf('Zustandsermittlung: %s\n', Zustandsermittlung(simparams.Zustandsermittlung))

% Vorsteuerung MCD
simparams.regler.vorst.C = 0.95;
simparams.regler.vorst.D = 0.95;
simparams.regler.vorst.x0_p_c076 = 10*SchlittenPendelParamsReg.x0_p_c076;

if ~exist('kpv', 'var')
    kpv = 150;
end
simparams.regler.kpv = kpv;
fprintf('a/v-Regler Kpv: %f\n', simparams.regler.kpv)

end