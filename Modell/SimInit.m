
equations = SchlittenPendelSym()

MotorParameter = struct("Umin",-1,"Umax",1,"Fmax",1,"Fmin",-1) %dummy
%SchlittenPendelParameter = 

sys = SchlittenPendelNLZSR(equations,SchlittenPendelParameter)
sys2sfct(sys,'SchlittenPendelFunc','M')

SchlittenPendelParameter.x0 = [0 0 pi 0 0.1 0];

simparams.gesamtmodell.motor=MotorParameter;
simparams.gesamtmodell.schlittenpendel=SchlittenPendelParameter;