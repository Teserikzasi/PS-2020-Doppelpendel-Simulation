function [ode, x, u]  = getODE_Fauve()
% gibt Zustandsgleichungen in Casadi-Symbolik zurück

import casadi.*
%global SchlittenPendelParams
%SPP = SchlittenPendelParams;
SPP = SchlittenPendelParams_Apprich09();

% Zustände
x1=SX.sym('x1'); x2=SX.sym('x2'); x3=SX.sym('x3'); x4=SX.sym('x4'); x5=SX.sym('x5'); x6=SX.sym('x6');

% Eingänge
u = SX.sym('u');

% Modellparameter
m0=SPP.m0; m1=SPP.m1; m2=SPP.m2;
J1=SPP.J1; J2=SPP.J2;
l1=SPP.l1; l2=SPP.l2;
s1=SPP.s1; s2=SPP.s2;
d0=SPP.d0; d1=SPP.d1; d2=SPP.d2;
g=SPP.g; 

% Gleichungen
f1 = x2;
f2 = ((m2*s2^2 + J2)*(l1*m2 + m1*s1)*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)) + (m2*s2^2 + J2)*(m2*l1^2 + m1*s1^2 + J1)*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2) + m1*s2*cos(x5)*(m2*l1^2 + m1*s1^2 + J1)*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)) - l1^2*m2^2*s2^2*cos(x3 - x5)^2*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2) - l1*m2*s2*cos(x3 - x5)*(l1*m2 + m1*s1)*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)) - l1*m1*m2*s2^2*cos(x3 - x5)*cos(x5)*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)))/((m2*s2^2 + J2)*(m0 + m1 + m2)*(m2*l1^2 + m1*s1^2 + J1) - cos(x3)*(m2*s2^2 + J2)*(l1*m2 + m1*s1)^2 - m1*m2*s2^2*cos(x5)^2*(m2*l1^2 + m1*s1^2 + J1) - l1^2*m2^2*s2^2*cos(x3 - x5)^2*(m0 + m1 + m2) + l1*m2^2*s2^2*cos(x3 - x5)*cos(x5)*(l1*m2 + m1*s1) + l1*m1*m2*s2^2*cos(x3 - x5)*cos(x3)*cos(x5)*(l1*m2 + m1*s1));
f3 = x4;
f4 = ((m2*s2^2 + J2)*(m0 + m1 + m2)*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)) + cos(x3)*(m2*s2^2 + J2)*(l1*m2 + m1*s1)*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2) - m1*m2*s2^2*cos(x5)^2*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)) - l1*m2^2*s2^2*cos(x3 - x5)*cos(x5)*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2) - l1*m2*s2*cos(x3 - x5)*(m0 + m1 + m2)*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)) + m1*s2*cos(x3)*cos(x5)*(l1*m2 + m1*s1)*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)))/((m2*s2^2 + J2)*(m0 + m1 + m2)*(m2*l1^2 + m1*s1^2 + J1) - cos(x3)*(m2*s2^2 + J2)*(l1*m2 + m1*s1)^2 - m1*m2*s2^2*cos(x5)^2*(m2*l1^2 + m1*s1^2 + J1) - l1^2*m2^2*s2^2*cos(x3 - x5)^2*(m0 + m1 + m2) + l1*m2^2*s2^2*cos(x3 - x5)*cos(x5)*(l1*m2 + m1*s1) + l1*m1*m2*s2^2*cos(x3 - x5)*cos(x3)*cos(x5)*(l1*m2 + m1*s1));
f5 = x6;
f6 = -(cos(x3)*(l1*m2 + m1*s1)^2*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)) - (m0 + m1 + m2)*(m2*l1^2 + m1*s1^2 + J1)*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)) - m2*s2*cos(x5)*(m2*l1^2 + m1*s1^2 + J1)*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2) - m2*s2*cos(x5)*(l1*m2 + m1*s1)*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)) + l1*m2*s2*cos(x3 - x5)*(m0 + m1 + m2)*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)) + l1*m2*s2*cos(x3 - x5)*cos(x3)*(l1*m2 + m1*s1)*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2))/((m2*s2^2 + J2)*(m0 + m1 + m2)*(m2*l1^2 + m1*s1^2 + J1) - cos(x3)*(m2*s2^2 + J2)*(l1*m2 + m1*s1)^2 - m1*m2*s2^2*cos(x5)^2*(m2*l1^2 + m1*s1^2 + J1) - l1^2*m2^2*s2^2*cos(x3 - x5)^2*(m0 + m1 + m2) + l1*m2^2*s2^2*cos(x3 - x5)*cos(x5)*(l1*m2 + m1*s1) + l1*m1*m2*s2^2*cos(x3 - x5)*cos(x3)*cos(x5)*(l1*m2 + m1*s1));

ode = [f1; f2; f3; f4; f5; f6];
x = [x1; x2; x3; x4; x5; x6];

end

