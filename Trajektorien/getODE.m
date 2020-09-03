function [ode, x, u] = getODE(coulomb)
% gibt Zustandsgleichungen in Casadi-Symbolik zurück
% Für coulomb=0 vollständiges Entfernen der Coulombkraft aus den
% Gleichungen

import casadi.*
global SchlittenPendelParams
% Coulombreibung deaktivieren
% SchlittenPendelParams.Fc0=0; 
% SchlittenPendelParams.Mc10=0;
% SchlittenPendelParams.Mc20=0;
SPP = SchlittenPendelParams;

if ~exist('coulomb', 'var')
    coulomb=1;
end

% Zustände
x0=SX.sym('x0'); x0_p=SX.sym('x0_p'); 
phi1=SX.sym('phi1'); phi1_p=SX.sym('phi1_p'); 
phi2=SX.sym('phi2'); phi2_p=SX.sym('phi2_p');

% Eingänge
F = SX.sym('F');

% Modellparameter
m0=SPP.m0; m1=SPP.m1; m2=SPP.m2;
J1=SPP.J1; J2=SPP.J2;
l1=SPP.l1; l2=SPP.l2;
s1=SPP.s1; s2=SPP.s2;
d0=SPP.d0; d1=SPP.d1; d2=SPP.d2;
g=SPP.g; 
Fc0=SPP.Fc0; Mc10=SPP.Mc10; Mc20=SPP.Mc20;
x0_p_c076=SPP.x0_p_c076; phi1_p_c076=SPP.phi1_p_c076; phi2_p_c076=SPP.phi2_p_c076;

% Gleichungen
f1 = x0_p;
f3 = phi1_p;
f5 = phi2_p;
if coulomb>0
    f2 = -(2*Fc0*J1*J2*tanh(x0_p/x0_p_c076) - F*l1^2*m2^2*s2^2 - 2*F*J2*l1^2*m2 - 2*F*J2*m1*s1^2 - 2*F*J1*m2*s2^2 - 2*F*J1*J2 + 2*J1*J2*d0*x0_p - 2*F*m1*m2*s1^2*s2^2 + Fc0*l1^2*m2^2*s2^2*tanh(x0_p/x0_p_c076) + 2*Fc0*J2*l1^2*m2*tanh(x0_p/x0_p_c076) + 2*Fc0*J2*m1*s1^2*tanh(x0_p/x0_p_c076) + 2*Fc0*J1*m2*s2^2*tanh(x0_p/x0_p_c076) + F*l1^2*m2^2*s2^2*cos(2*phi1 - 2*phi2) + d0*l1^2*m2^2*s2^2*x0_p + 2*J2*d0*l1^2*m2*x0_p + 2*J2*d0*m1*s1^2*x0_p + 2*J1*d0*m2*s2^2*x0_p - J2*g*l1^2*m2^2*sin(2*phi1) - J2*g*m1^2*s1^2*sin(2*phi1) - J1*g*m2^2*s2^2*sin(2*phi2) + 2*J2*l1^3*m2^2*phi1_p^2*sin(phi1) + 2*J2*m1^2*phi1_p^2*s1^3*sin(phi1) + 2*J1*m2^2*phi2_p^2*s2^3*sin(phi2) - d0*l1^2*m2^2*s2^2*x0_p*cos(2*phi1 - 2*phi2) + d1*l1*m2^2*phi1_p*s2^2*cos(phi1) + d2*l1*m2^2*phi1_p*s2^2*cos(phi1) - d2*l1*m2^2*phi2_p*s2^2*cos(phi1) - d2*l1^2*m2^2*phi1_p*s2*cos(phi2) + d2*l1^2*m2^2*phi2_p*s2*cos(phi2) + 2*J2*d1*l1*m2*phi1_p*cos(phi1) + 2*J2*d2*l1*m2*phi1_p*cos(phi1) - 2*J2*d2*l1*m2*phi2_p*cos(phi1) + 2*J2*d1*m1*phi1_p*s1*cos(phi1) + 2*J2*d2*m1*phi1_p*s1*cos(phi1) - 2*J2*d2*m1*phi2_p*s1*cos(phi1) - 2*J1*d2*m2*phi1_p*s2*cos(phi2) + 2*J1*d2*m2*phi2_p*s2*cos(phi2) - d1*l1*m2^2*phi1_p*s2^2*cos(phi1 - 2*phi2) - d2*l1*m2^2*phi1_p*s2^2*cos(phi1 - 2*phi2) + d2*l1*m2^2*phi2_p*s2^2*cos(phi1 - 2*phi2) + 2*Fc0*m1*m2*s1^2*s2^2*tanh(x0_p/x0_p_c076) + Mc20*l1^2*m2^2*s2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(2*phi1 - phi2) + J1*l1*m2^2*phi1_p^2*s2^2*sin(phi1) + J2*l1^2*m2^2*phi2_p^2*s2*sin(phi2) + 2*J1*J2*l1*m2*phi1_p^2*sin(phi1) + 2*J1*J2*m1*phi1_p^2*s1*sin(phi1) + 2*J1*J2*m2*phi2_p^2*s2*sin(phi2) - Fc0*l1^2*m2^2*s2^2*tanh(x0_p/x0_p_c076)*cos(2*phi1 - 2*phi2) - J1*l1*m2^2*phi1_p^2*s2^2*sin(phi1 - 2*phi2) + Mc10*l1*m2^2*s2^2*tanh(phi1_p/phi1_p_c076)*cos(phi1) + d2*l1^2*m2^2*phi1_p*s2*cos(2*phi1 - phi2) - d2*l1^2*m2^2*phi2_p*s2*cos(2*phi1 - phi2) + 2*J2*Mc10*l1*m2*tanh(phi1_p/phi1_p_c076)*cos(phi1) + 2*d0*m1*m2*s1^2*s2^2*x0_p + 2*J2*Mc10*m1*s1*tanh(phi1_p/phi1_p_c076)*cos(phi1) - Mc10*l1*m2^2*s2^2*cos(phi1 - 2*phi2)*tanh(phi1_p/phi1_p_c076) + Mc20*l1*m2^2*s2^2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi1) - Mc20*l1^2*m2^2*s2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi2) + 2*J2*Mc20*l1*m2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi1) - g*m1^2*m2*s1^2*s2^2*sin(2*phi1) - g*m1*m2^2*s1^2*s2^2*sin(2*phi2) + 2*J2*Mc20*m1*s1*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi1) - 2*J1*Mc20*m2*s2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi2) + 2*m1^2*m2*phi1_p^2*s1^3*s2^2*sin(phi1) + 2*m1*m2^2*phi2_p^2*s1^2*s2^3*sin(phi2) + J2*l1^2*m2^2*phi2_p^2*s2*sin(2*phi1 - phi2) - Mc20*l1*m2^2*s2^2*cos(phi1 - 2*phi2)*tanh((phi1_p - phi2_p)/phi2_p_c076) - 2*J2*g*l1*m1*m2*s1*sin(2*phi1) + 2*d1*m1*m2*phi1_p*s1*s2^2*cos(phi1) + 2*d2*m1*m2*phi1_p*s1*s2^2*cos(phi1) - 2*d2*m1*m2*phi1_p*s1^2*s2*cos(phi2) - 2*d2*m1*m2*phi2_p*s1*s2^2*cos(phi1) + 2*d2*m1*m2*phi2_p*s1^2*s2*cos(phi2) + l1*m1*m2^2*phi1_p^2*s1^2*s2^2*sin(phi1) + l1^2*m1*m2^2*phi1_p^2*s1*s2^2*sin(phi1) + 2*J2*l1*m1*m2*phi1_p^2*s1^2*sin(phi1) + 2*J2*l1^2*m1*m2*phi1_p^2*s1*sin(phi1) + 2*J1*m1*m2*phi1_p^2*s1*s2^2*sin(phi1) + 2*J2*m1*m2*phi2_p^2*s1^2*s2*sin(phi2) + l1*m1*m2^2*phi2_p^2*s1*s2^3*sin(2*phi1 - phi2) - l1*m1*m2^2*phi1_p^2*s1^2*s2^2*sin(phi1 - 2*phi2) + l1^2*m1*m2^2*phi1_p^2*s1*s2^2*sin(phi1 - 2*phi2) + 2*Mc10*m1*m2*s1*s2^2*tanh(phi1_p/phi1_p_c076)*cos(phi1) + 2*Mc20*m1*m2*s1*s2^2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi1) - 2*Mc20*m1*m2*s1^2*s2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi2) - g*l1*m1*m2^2*s1*s2^2*sin(2*phi1) + g*l1*m1*m2^2*s1*s2^2*sin(2*phi2) - l1*m1*m2^2*phi2_p^2*s1*s2^3*sin(phi2) + J2*l1*m1*m2*phi2_p^2*s1*s2*sin(2*phi1 - phi2) + d2*l1*m1*m2*phi1_p*s1*s2*cos(phi2) - d2*l1*m1*m2*phi2_p*s1*s2*cos(phi2) + Mc20*l1*m1*m2*s1*s2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(2*phi1 - phi2) - J2*l1*m1*m2*phi2_p^2*s1*s2*sin(phi2) + d2*l1*m1*m2*phi1_p*s1*s2*cos(2*phi1 - phi2) - d2*l1*m1*m2*phi2_p*s1*s2*cos(2*phi1 - phi2) + Mc20*l1*m1*m2*s1*s2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi2))/(J2*l1^2*m2^2 + J2*m1^2*s1^2 + J1*m2^2*s2^2 + 2*J1*J2*m0 + 2*J1*J2*m1 + 2*J1*J2*m2 + l1^2*m0*m2^2*s2^2 + l1^2*m1*m2^2*s2^2 + m1*m2^2*s1^2*s2^2 + m1^2*m2*s1^2*s2^2 + 2*J2*l1^2*m0*m2 + 2*J2*l1^2*m1*m2 + 2*J2*m0*m1*s1^2 + 2*J1*m0*m2*s2^2 + 2*J1*m1*m2*s2^2 + 2*J2*m1*m2*s1^2 - J2*l1^2*m2^2*cos(2*phi1) - J2*m1^2*s1^2*cos(2*phi1) - J1*m2^2*s2^2*cos(2*phi2) - l1*m1*m2^2*s1*s2^2 + 2*m0*m1*m2*s1^2*s2^2 - 2*J2*l1*m1*m2*s1 - m1^2*m2*s1^2*s2^2*cos(2*phi1) - m1*m2^2*s1^2*s2^2*cos(2*phi2) - l1^2*m0*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1^2*m1*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1*m1*m2^2*s1*s2^2*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi2) - 2*J2*l1*m1*m2*s1*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi1 - 2*phi2));
    f4 = -(Mc10*m2^2*s2^2*tanh(phi1_p/phi1_p_c076) + 2*J2*Mc10*m0*tanh(phi1_p/phi1_p_c076) + 2*J2*Mc10*m1*tanh(phi1_p/phi1_p_c076) + 2*J2*Mc10*m2*tanh(phi1_p/phi1_p_c076) + Mc20*m2^2*s2^2*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*J2*Mc20*m0*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*J2*Mc20*m1*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*J2*Mc20*m2*tanh((phi1_p - phi2_p)/phi2_p_c076) + d1*m2^2*phi1_p*s2^2 + d2*m2^2*phi1_p*s2^2 - d2*m2^2*phi2_p*s2^2 + 2*J2*d1*m0*phi1_p + 2*J2*d1*m1*phi1_p + 2*J2*d2*m0*phi1_p + 2*J2*d1*m2*phi1_p - 2*J2*d2*m0*phi2_p + 2*J2*d2*m1*phi1_p - 2*J2*d2*m1*phi2_p + 2*J2*d2*m2*phi1_p - 2*J2*d2*m2*phi2_p - d1*m2^2*phi1_p*s2^2*cos(2*phi2) - d2*m2^2*phi1_p*s2^2*cos(2*phi2) + d2*m2^2*phi2_p*s2^2*cos(2*phi2) - 2*J2*g*l1*m2^2*sin(phi1) - 2*J2*g*m1^2*s1*sin(phi1) + J2*l1^2*m2^2*phi1_p^2*sin(2*phi1) + J2*m1^2*phi1_p^2*s1^2*sin(2*phi1) + 2*Mc10*m0*m2*s2^2*tanh(phi1_p/phi1_p_c076) + 2*Mc10*m1*m2*s2^2*tanh(phi1_p/phi1_p_c076) - F*l1*m2^2*s2^2*cos(phi1) - Mc10*m2^2*s2^2*tanh(phi1_p/phi1_p_c076)*cos(2*phi2) - 2*F*J2*l1*m2*cos(phi1) + 2*Mc20*m0*m2*s2^2*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*Mc20*m1*m2*s2^2*tanh((phi1_p - phi2_p)/phi2_p_c076) - 2*F*J2*m1*s1*cos(phi1) + F*l1*m2^2*s2^2*cos(phi1 - 2*phi2) - Mc20*m2^2*s2^2*cos(2*phi2)*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*d1*m0*m2*phi1_p*s2^2 + 2*d1*m1*m2*phi1_p*s2^2 + 2*d2*m0*m2*phi1_p*s2^2 - 2*d2*m0*m2*phi2_p*s2^2 + 2*d2*m1*m2*phi1_p*s2^2 - 2*d2*m1*m2*phi2_p*s2^2 + d0*l1*m2^2*s2^2*x0_p*cos(phi1) - g*l1*m0*m2^2*s2^2*sin(phi1) - g*l1*m1*m2^2*s2^2*sin(phi1) - g*m1*m2^2*s1*s2^2*sin(phi1) - 2*g*m1^2*m2*s1*s2^2*sin(phi1) + 2*J2*d0*l1*m2*x0_p*cos(phi1) + J2*l1*m2^2*phi2_p^2*s2*sin(phi1 - phi2) + 2*J2*d0*m1*s1*x0_p*cos(phi1) - 2*J2*g*l1*m0*m2*sin(phi1) - 2*J2*g*l1*m1*m2*sin(phi1) - Mc20*l1*m2^2*s2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi1 + phi2) - 2*J2*g*m0*m1*s1*sin(phi1) - 2*J2*g*m1*m2*s1*sin(phi1) - d0*l1*m2^2*s2^2*x0_p*cos(phi1 - 2*phi2) + m1^2*m2*phi1_p^2*s1^2*s2^2*sin(2*phi1) - g*l1*m0*m2^2*s2^2*sin(phi1 - 2*phi2) - g*l1*m1*m2^2*s2^2*sin(phi1 - 2*phi2) + g*m1*m2^2*s1*s2^2*sin(phi1 - 2*phi2) + m1*m2^2*phi2_p^2*s1*s2^3*sin(phi1 + phi2) + l1^2*m0*m2^2*phi1_p^2*s2^2*sin(2*phi1 - 2*phi2) + l1^2*m1*m2^2*phi1_p^2*s2^2*sin(2*phi1 - 2*phi2) - d2*l1*m2^2*phi1_p*s2*cos(phi1 + phi2) + d2*l1*m2^2*phi2_p*s2*cos(phi1 + phi2) - 2*F*m1*m2*s1*s2^2*cos(phi1) + Mc20*l1*m2^2*s2*cos(phi1 - phi2)*tanh((phi1_p - phi2_p)/phi2_p_c076) + Fc0*l1*m2^2*s2^2*tanh(x0_p/x0_p_c076)*cos(phi1) + 2*l1*m0*m2^2*phi2_p^2*s2^3*sin(phi1 - phi2) + 2*l1*m1*m2^2*phi2_p^2*s2^3*sin(phi1 - phi2) + 2*Fc0*J2*l1*m2*tanh(x0_p/x0_p_c076)*cos(phi1) - m1*m2^2*phi2_p^2*s1*s2^3*sin(phi1 - phi2) + 2*Fc0*J2*m1*s1*tanh(x0_p/x0_p_c076)*cos(phi1) - Fc0*l1*m2^2*s2^2*cos(phi1 - 2*phi2)*tanh(x0_p/x0_p_c076) + J2*l1*m2^2*phi2_p^2*s2*sin(phi1 + phi2) + d2*l1*m2^2*phi1_p*s2*cos(phi1 - phi2) - d2*l1*m2^2*phi2_p*s2*cos(phi1 - phi2) + 2*d0*m1*m2*s1*s2^2*x0_p*cos(phi1) - 2*g*m0*m1*m2*s1*s2^2*sin(phi1) + 2*J2*l1*m0*m2*phi2_p^2*s2*sin(phi1 - phi2) + 2*J2*l1*m1*m2*phi2_p^2*s2*sin(phi1 - phi2) - J2*m1*m2*phi2_p^2*s1*s2*sin(phi1 - phi2) - Mc20*m1*m2*s1*s2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi1 + phi2) + l1*m1*m2^2*phi1_p^2*s1*s2^2*sin(2*phi1) + 2*J2*l1*m1*m2*phi1_p^2*s1*sin(2*phi1) - l1*m1*m2^2*phi1_p^2*s1*s2^2*sin(2*phi1 - 2*phi2) - d2*m1*m2*phi1_p*s1*s2*cos(phi1 + phi2) + d2*m1*m2*phi2_p*s1*s2*cos(phi1 + phi2) + 2*Mc20*l1*m0*m2*s2*cos(phi1 - phi2)*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*Mc20*l1*m1*m2*s2*cos(phi1 - phi2)*tanh((phi1_p - phi2_p)/phi2_p_c076) - Mc20*m1*m2*s1*s2*cos(phi1 - phi2)*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*Fc0*m1*m2*s1*s2^2*tanh(x0_p/x0_p_c076)*cos(phi1) + J2*m1*m2*phi2_p^2*s1*s2*sin(phi1 + phi2) + 2*d2*l1*m0*m2*phi1_p*s2*cos(phi1 - phi2) - 2*d2*l1*m0*m2*phi2_p*s2*cos(phi1 - phi2) + 2*d2*l1*m1*m2*phi1_p*s2*cos(phi1 - phi2) - 2*d2*l1*m1*m2*phi2_p*s2*cos(phi1 - phi2) - d2*m1*m2*phi1_p*s1*s2*cos(phi1 - phi2) + d2*m1*m2*phi2_p*s1*s2*cos(phi1 - phi2))/(J2*l1^2*m2^2 + J2*m1^2*s1^2 + J1*m2^2*s2^2 + 2*J1*J2*m0 + 2*J1*J2*m1 + 2*J1*J2*m2 + l1^2*m0*m2^2*s2^2 + l1^2*m1*m2^2*s2^2 + m1*m2^2*s1^2*s2^2 + m1^2*m2*s1^2*s2^2 + 2*J2*l1^2*m0*m2 + 2*J2*l1^2*m1*m2 + 2*J2*m0*m1*s1^2 + 2*J1*m0*m2*s2^2 + 2*J1*m1*m2*s2^2 + 2*J2*m1*m2*s1^2 - J2*l1^2*m2^2*cos(2*phi1) - J2*m1^2*s1^2*cos(2*phi1) - J1*m2^2*s2^2*cos(2*phi2) - l1*m1*m2^2*s1*s2^2 + 2*m0*m1*m2*s1^2*s2^2 - 2*J2*l1*m1*m2*s1 - m1^2*m2*s1^2*s2^2*cos(2*phi1) - m1*m2^2*s1^2*s2^2*cos(2*phi2) - l1^2*m0*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1^2*m1*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1*m1*m2^2*s1*s2^2*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi2) - 2*J2*l1*m1*m2*s1*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi1 - 2*phi2));
    f6 = (Mc20*l1^2*m2^2*tanh((phi1_p - phi2_p)/phi2_p_c076) + Mc20*m1^2*s1^2*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*J1*Mc20*m0*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*J1*Mc20*m1*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*J1*Mc20*m2*tanh((phi1_p - phi2_p)/phi2_p_c076) + d2*l1^2*m2^2*phi1_p - d2*l1^2*m2^2*phi2_p + d2*m1^2*phi1_p*s1^2 - d2*m1^2*phi2_p*s1^2 + 2*J1*d2*m0*phi1_p - 2*J1*d2*m0*phi2_p + 2*J1*d2*m1*phi1_p - 2*J1*d2*m1*phi2_p + 2*J1*d2*m2*phi1_p - 2*J1*d2*m2*phi2_p - d2*m1^2*phi1_p*s1^2*cos(2*phi1) + d2*m1^2*phi2_p*s1^2*cos(2*phi1) - F*l1^2*m2^2*s2*cos(2*phi1 - phi2) + 2*J1*g*m2^2*s2*sin(phi2) - J1*m2^2*phi2_p^2*s2^2*sin(2*phi2) + F*l1^2*m2^2*s2*cos(phi2) + 2*Mc20*l1^2*m0*m2*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*Mc20*l1^2*m1*m2*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*Mc20*m0*m1*s1^2*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*Mc20*m1*m2*s1^2*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*F*J1*m2*s2*cos(phi2) - Mc20*l1^2*m2^2*cos(2*phi1)*tanh((phi1_p - phi2_p)/phi2_p_c076) - Mc20*m1^2*s1^2*cos(2*phi1)*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*d2*l1^2*m0*m2*phi1_p - 2*d2*l1^2*m0*m2*phi2_p + 2*d2*l1^2*m1*m2*phi1_p - 2*d2*l1^2*m1*m2*phi2_p + 2*d2*m0*m1*phi1_p*s1^2 - 2*d2*m0*m1*phi2_p*s1^2 + 2*d2*m1*m2*phi1_p*s1^2 - 2*d2*m1*m2*phi2_p*s1^2 - d2*l1^2*m2^2*phi1_p*cos(2*phi1) + d2*l1^2*m2^2*phi2_p*cos(2*phi1) - Mc10*l1*m2^2*s2*tanh(phi1_p/phi1_p_c076)*cos(phi1 + phi2) - d0*l1^2*m2^2*s2*x0_p*cos(phi2) + g*l1^2*m0*m2^2*s2*sin(phi2) + g*l1^2*m1*m2^2*s2*sin(phi2) + 2*g*m1*m2^2*s1^2*s2*sin(phi2) + g*m1^2*m2*s1^2*s2*sin(phi2) + Fc0*l1^2*m2^2*s2*tanh(x0_p/x0_p_c076)*cos(2*phi1 - phi2) + J1*l1*m2^2*phi1_p^2*s2*sin(phi1 - phi2) - 2*J1*d0*m2*s2*x0_p*cos(phi2) - Mc20*l1*m2^2*s2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi1 + phi2) + 2*J1*g*m0*m2*s2*sin(phi2) + 2*J1*g*m1*m2*s2*sin(phi2) - m1*m2^2*phi2_p^2*s1^2*s2^2*sin(2*phi2) - m1^2*m2*phi1_p^2*s1^3*s2*sin(phi1 + phi2) + Mc10*l1*m2^2*s2*cos(phi1 - phi2)*tanh(phi1_p/phi1_p_c076) + l1^2*m0*m2^2*phi2_p^2*s2^2*sin(2*phi1 - 2*phi2) + l1^2*m1*m2^2*phi2_p^2*s2^2*sin(2*phi1 - 2*phi2) - d1*l1*m2^2*phi1_p*s2*cos(phi1 + phi2) - d2*l1*m2^2*phi1_p*s2*cos(phi1 + phi2) + d2*l1*m2^2*phi2_p*s2*cos(phi1 + phi2) + 2*F*m1*m2*s1^2*s2*cos(phi2) + Mc20*l1*m2^2*s2*cos(phi1 - phi2)*tanh((phi1_p - phi2_p)/phi2_p_c076) - Fc0*l1^2*m2^2*s2*tanh(x0_p/x0_p_c076)*cos(phi2) + d0*l1^2*m2^2*s2*x0_p*cos(2*phi1 - phi2) - 2*Mc20*l1*m1*m2*s1*tanh((phi1_p - phi2_p)/phi2_p_c076) - g*l1^2*m0*m2^2*s2*sin(2*phi1 - phi2) - g*l1^2*m1*m2^2*s2*sin(2*phi1 - phi2) + g*m1^2*m2*s1^2*s2*sin(2*phi1 - phi2) + 2*l1^3*m0*m2^2*phi1_p^2*s2*sin(phi1 - phi2) + 2*l1^3*m1*m2^2*phi1_p^2*s2*sin(phi1 - phi2) - m1^2*m2*phi1_p^2*s1^3*s2*sin(phi1 - phi2) - 2*Fc0*J1*m2*s2*tanh(x0_p/x0_p_c076)*cos(phi2) - J1*l1*m2^2*phi1_p^2*s2*sin(phi1 + phi2) + d1*l1*m2^2*phi1_p*s2*cos(phi1 - phi2) + d2*l1*m2^2*phi1_p*s2*cos(phi1 - phi2) - d2*l1*m2^2*phi2_p*s2*cos(phi1 - phi2) - 2*d2*l1*m1*m2*phi1_p*s1 + 2*d2*l1*m1*m2*phi2_p*s1 - 2*d2*l1*m1*m2*phi1_p*s1*cos(2*phi1) + 2*d2*l1*m1*m2*phi2_p*s1*cos(2*phi1) - Mc10*m1*m2*s1*s2*tanh(phi1_p/phi1_p_c076)*cos(phi1 + phi2) + l1*m1*m2^2*phi1_p^2*s1^2*s2*sin(phi1 - phi2) + l1*m1^2*m2*phi1_p^2*s1^2*s2*sin(phi1 - phi2) - 3*l1^2*m1*m2^2*phi1_p^2*s1*s2*sin(phi1 - phi2) - 2*d0*m1*m2*s1^2*s2*x0_p*cos(phi2) - F*l1*m1*m2*s1*s2*cos(2*phi1 - phi2) - 3*g*l1*m1*m2^2*s1*s2*sin(phi2) - g*l1*m1^2*m2*s1*s2*sin(phi2) + 2*g*m0*m1*m2*s1^2*s2*sin(phi2) + 2*J1*l1*m0*m2*phi1_p^2*s2*sin(phi1 - phi2) + 2*J1*l1*m1*m2*phi1_p^2*s2*sin(phi1 - phi2) - J1*m1*m2*phi1_p^2*s1*s2*sin(phi1 - phi2) - Mc20*m1*m2*s1*s2*tanh((phi1_p - phi2_p)/phi2_p_c076)*cos(phi1 + phi2) + l1*m1*m2^2*phi2_p^2*s1*s2^2*sin(2*phi2) + 2*Mc10*l1*m0*m2*s2*cos(phi1 - phi2)*tanh(phi1_p/phi1_p_c076) + 2*Mc10*l1*m1*m2*s2*cos(phi1 - phi2)*tanh(phi1_p/phi1_p_c076) - Mc10*m1*m2*s1*s2*cos(phi1 - phi2)*tanh(phi1_p/phi1_p_c076) - l1*m1*m2^2*phi2_p^2*s1*s2^2*sin(2*phi1 - 2*phi2) - d1*m1*m2*phi1_p*s1*s2*cos(phi1 + phi2) - d2*m1*m2*phi1_p*s1*s2*cos(phi1 + phi2) + d2*m1*m2*phi2_p*s1*s2*cos(phi1 + phi2) - F*l1*m1*m2*s1*s2*cos(phi2) + 2*Mc20*l1*m0*m2*s2*cos(phi1 - phi2)*tanh((phi1_p - phi2_p)/phi2_p_c076) + 2*Mc20*l1*m1*m2*s2*cos(phi1 - phi2)*tanh((phi1_p - phi2_p)/phi2_p_c076) - Mc20*m1*m2*s1*s2*cos(phi1 - phi2)*tanh((phi1_p - phi2_p)/phi2_p_c076) - 2*Fc0*m1*m2*s1^2*s2*tanh(x0_p/x0_p_c076)*cos(phi2) + g*l1*m1*m2^2*s1*s2*sin(2*phi1 - phi2) - g*l1*m1^2*m2*s1*s2*sin(2*phi1 - phi2) - l1*m1*m2^2*phi1_p^2*s1^2*s2*sin(phi1 + phi2) + l1*m1^2*m2*phi1_p^2*s1^2*s2*sin(phi1 + phi2) + l1^2*m1*m2^2*phi1_p^2*s1*s2*sin(phi1 + phi2) - 2*Mc20*l1*m1*m2*s1*cos(2*phi1)*tanh((phi1_p - phi2_p)/phi2_p_c076) - J1*m1*m2*phi1_p^2*s1*s2*sin(phi1 + phi2) + 2*d1*l1*m0*m2*phi1_p*s2*cos(phi1 - phi2) + 2*d1*l1*m1*m2*phi1_p*s2*cos(phi1 - phi2) + 2*d2*l1*m0*m2*phi1_p*s2*cos(phi1 - phi2) - 2*d2*l1*m0*m2*phi2_p*s2*cos(phi1 - phi2) + 2*d2*l1*m1*m2*phi1_p*s2*cos(phi1 - phi2) - 2*d2*l1*m1*m2*phi2_p*s2*cos(phi1 - phi2) - d1*m1*m2*phi1_p*s1*s2*cos(phi1 - phi2) - d2*m1*m2*phi1_p*s1*s2*cos(phi1 - phi2) + d2*m1*m2*phi2_p*s1*s2*cos(phi1 - phi2) + 2*l1*m0*m1*m2*phi1_p^2*s1^2*s2*sin(phi1 - phi2) + d0*l1*m1*m2*s1*s2*x0_p*cos(phi2) - g*l1*m0*m1*m2*s1*s2*sin(phi2) + Fc0*l1*m1*m2*s1*s2*tanh(x0_p/x0_p_c076)*cos(2*phi1 - phi2) + Fc0*l1*m1*m2*s1*s2*tanh(x0_p/x0_p_c076)*cos(phi2) + d0*l1*m1*m2*s1*s2*x0_p*cos(2*phi1 - phi2) - g*l1*m0*m1*m2*s1*s2*sin(2*phi1 - phi2))/(J2*l1^2*m2^2 + J2*m1^2*s1^2 + J1*m2^2*s2^2 + 2*J1*J2*m0 + 2*J1*J2*m1 + 2*J1*J2*m2 + l1^2*m0*m2^2*s2^2 + l1^2*m1*m2^2*s2^2 + m1*m2^2*s1^2*s2^2 + m1^2*m2*s1^2*s2^2 + 2*J2*l1^2*m0*m2 + 2*J2*l1^2*m1*m2 + 2*J2*m0*m1*s1^2 + 2*J1*m0*m2*s2^2 + 2*J1*m1*m2*s2^2 + 2*J2*m1*m2*s1^2 - J2*l1^2*m2^2*cos(2*phi1) - J2*m1^2*s1^2*cos(2*phi1) - J1*m2^2*s2^2*cos(2*phi2) - l1*m1*m2^2*s1*s2^2 + 2*m0*m1*m2*s1^2*s2^2 - 2*J2*l1*m1*m2*s1 - m1^2*m2*s1^2*s2^2*cos(2*phi1) - m1*m2^2*s1^2*s2^2*cos(2*phi2) - l1^2*m0*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1^2*m1*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1*m1*m2^2*s1*s2^2*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi2) - 2*J2*l1*m1*m2*s1*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi1 - 2*phi2));
else
    f2 = -(2*J1*J2*d0*x0_p - F*l1^2*m2^2*s2^2 - 2*F*J2*l1^2*m2 - 2*F*J2*m1*s1^2 - 2*F*J1*m2*s2^2 - 2*F*J1*J2 - 2*F*m1*m2*s1^2*s2^2 + F*l1^2*m2^2*s2^2*cos(2*phi1 - 2*phi2) + d0*l1^2*m2^2*s2^2*x0_p + 2*J2*d0*l1^2*m2*x0_p + 2*J2*d0*m1*s1^2*x0_p + 2*J1*d0*m2*s2^2*x0_p - J2*g*l1^2*m2^2*sin(2*phi1) - J2*g*m1^2*s1^2*sin(2*phi1) - J1*g*m2^2*s2^2*sin(2*phi2) + 2*J2*l1^3*m2^2*phi1_p^2*sin(phi1) + 2*J2*m1^2*phi1_p^2*s1^3*sin(phi1) + 2*J1*m2^2*phi2_p^2*s2^3*sin(phi2) - d0*l1^2*m2^2*s2^2*x0_p*cos(2*phi1 - 2*phi2) + d1*l1*m2^2*phi1_p*s2^2*cos(phi1) + d2*l1*m2^2*phi1_p*s2^2*cos(phi1) - d2*l1*m2^2*phi2_p*s2^2*cos(phi1) - d2*l1^2*m2^2*phi1_p*s2*cos(phi2) + d2*l1^2*m2^2*phi2_p*s2*cos(phi2) + 2*J2*d1*l1*m2*phi1_p*cos(phi1) + 2*J2*d2*l1*m2*phi1_p*cos(phi1) - 2*J2*d2*l1*m2*phi2_p*cos(phi1) + 2*J2*d1*m1*phi1_p*s1*cos(phi1) + 2*J2*d2*m1*phi1_p*s1*cos(phi1) - 2*J2*d2*m1*phi2_p*s1*cos(phi1) - 2*J1*d2*m2*phi1_p*s2*cos(phi2) + 2*J1*d2*m2*phi2_p*s2*cos(phi2) - d1*l1*m2^2*phi1_p*s2^2*cos(phi1 - 2*phi2) - d2*l1*m2^2*phi1_p*s2^2*cos(phi1 - 2*phi2) + d2*l1*m2^2*phi2_p*s2^2*cos(phi1 - 2*phi2) + J1*l1*m2^2*phi1_p^2*s2^2*sin(phi1) + J2*l1^2*m2^2*phi2_p^2*s2*sin(phi2) + 2*J1*J2*l1*m2*phi1_p^2*sin(phi1) + 2*J1*J2*m1*phi1_p^2*s1*sin(phi1) + 2*J1*J2*m2*phi2_p^2*s2*sin(phi2) - J1*l1*m2^2*phi1_p^2*s2^2*sin(phi1 - 2*phi2) + d2*l1^2*m2^2*phi1_p*s2*cos(2*phi1 - phi2) - d2*l1^2*m2^2*phi2_p*s2*cos(2*phi1 - phi2) + 2*d0*m1*m2*s1^2*s2^2*x0_p - g*m1^2*m2*s1^2*s2^2*sin(2*phi1) - g*m1*m2^2*s1^2*s2^2*sin(2*phi2) + 2*m1^2*m2*phi1_p^2*s1^3*s2^2*sin(phi1) + 2*m1*m2^2*phi2_p^2*s1^2*s2^3*sin(phi2) + J2*l1^2*m2^2*phi2_p^2*s2*sin(2*phi1 - phi2) - 2*J2*g*l1*m1*m2*s1*sin(2*phi1) + 2*d1*m1*m2*phi1_p*s1*s2^2*cos(phi1) + 2*d2*m1*m2*phi1_p*s1*s2^2*cos(phi1) - 2*d2*m1*m2*phi1_p*s1^2*s2*cos(phi2) - 2*d2*m1*m2*phi2_p*s1*s2^2*cos(phi1) + 2*d2*m1*m2*phi2_p*s1^2*s2*cos(phi2) + l1*m1*m2^2*phi1_p^2*s1^2*s2^2*sin(phi1) + l1^2*m1*m2^2*phi1_p^2*s1*s2^2*sin(phi1) + 2*J2*l1*m1*m2*phi1_p^2*s1^2*sin(phi1) + 2*J2*l1^2*m1*m2*phi1_p^2*s1*sin(phi1) + 2*J1*m1*m2*phi1_p^2*s1*s2^2*sin(phi1) + 2*J2*m1*m2*phi2_p^2*s1^2*s2*sin(phi2) + l1*m1*m2^2*phi2_p^2*s1*s2^3*sin(2*phi1 - phi2) - l1*m1*m2^2*phi1_p^2*s1^2*s2^2*sin(phi1 - 2*phi2) + l1^2*m1*m2^2*phi1_p^2*s1*s2^2*sin(phi1 - 2*phi2) - g*l1*m1*m2^2*s1*s2^2*sin(2*phi1) + g*l1*m1*m2^2*s1*s2^2*sin(2*phi2) - l1*m1*m2^2*phi2_p^2*s1*s2^3*sin(phi2) + J2*l1*m1*m2*phi2_p^2*s1*s2*sin(2*phi1 - phi2) + d2*l1*m1*m2*phi1_p*s1*s2*cos(phi2) - d2*l1*m1*m2*phi2_p*s1*s2*cos(phi2) - J2*l1*m1*m2*phi2_p^2*s1*s2*sin(phi2) + d2*l1*m1*m2*phi1_p*s1*s2*cos(2*phi1 - phi2) - d2*l1*m1*m2*phi2_p*s1*s2*cos(2*phi1 - phi2))/(J2*l1^2*m2^2 + J2*m1^2*s1^2 + J1*m2^2*s2^2 + 2*J1*J2*m0 + 2*J1*J2*m1 + 2*J1*J2*m2 + l1^2*m0*m2^2*s2^2 + l1^2*m1*m2^2*s2^2 + m1*m2^2*s1^2*s2^2 + m1^2*m2*s1^2*s2^2 + 2*J2*l1^2*m0*m2 + 2*J2*l1^2*m1*m2 + 2*J2*m0*m1*s1^2 + 2*J1*m0*m2*s2^2 + 2*J1*m1*m2*s2^2 + 2*J2*m1*m2*s1^2 - J2*l1^2*m2^2*cos(2*phi1) - J2*m1^2*s1^2*cos(2*phi1) - J1*m2^2*s2^2*cos(2*phi2) - l1*m1*m2^2*s1*s2^2 + 2*m0*m1*m2*s1^2*s2^2 - 2*J2*l1*m1*m2*s1 - m1^2*m2*s1^2*s2^2*cos(2*phi1) - m1*m2^2*s1^2*s2^2*cos(2*phi2) - l1^2*m0*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1^2*m1*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1*m1*m2^2*s1*s2^2*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi2) - 2*J2*l1*m1*m2*s1*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi1 - 2*phi2));
    f4 = -(d1*m2^2*phi1_p*s2^2 + d2*m2^2*phi1_p*s2^2 - d2*m2^2*phi2_p*s2^2 + 2*J2*d1*m0*phi1_p + 2*J2*d1*m1*phi1_p + 2*J2*d2*m0*phi1_p + 2*J2*d1*m2*phi1_p - 2*J2*d2*m0*phi2_p + 2*J2*d2*m1*phi1_p - 2*J2*d2*m1*phi2_p + 2*J2*d2*m2*phi1_p - 2*J2*d2*m2*phi2_p - d1*m2^2*phi1_p*s2^2*cos(2*phi2) - d2*m2^2*phi1_p*s2^2*cos(2*phi2) + d2*m2^2*phi2_p*s2^2*cos(2*phi2) - 2*J2*g*l1*m2^2*sin(phi1) - 2*J2*g*m1^2*s1*sin(phi1) + J2*l1^2*m2^2*phi1_p^2*sin(2*phi1) + J2*m1^2*phi1_p^2*s1^2*sin(2*phi1) - F*l1*m2^2*s2^2*cos(phi1) - 2*F*J2*l1*m2*cos(phi1) - 2*F*J2*m1*s1*cos(phi1) + F*l1*m2^2*s2^2*cos(phi1 - 2*phi2) + 2*d1*m0*m2*phi1_p*s2^2 + 2*d1*m1*m2*phi1_p*s2^2 + 2*d2*m0*m2*phi1_p*s2^2 - 2*d2*m0*m2*phi2_p*s2^2 + 2*d2*m1*m2*phi1_p*s2^2 - 2*d2*m1*m2*phi2_p*s2^2 + d0*l1*m2^2*s2^2*x0_p*cos(phi1) - g*l1*m0*m2^2*s2^2*sin(phi1) - g*l1*m1*m2^2*s2^2*sin(phi1) - g*m1*m2^2*s1*s2^2*sin(phi1) - 2*g*m1^2*m2*s1*s2^2*sin(phi1) + 2*J2*d0*l1*m2*x0_p*cos(phi1) + J2*l1*m2^2*phi2_p^2*s2*sin(phi1 - phi2) + 2*J2*d0*m1*s1*x0_p*cos(phi1) - 2*J2*g*l1*m0*m2*sin(phi1) - 2*J2*g*l1*m1*m2*sin(phi1) - 2*J2*g*m0*m1*s1*sin(phi1) - 2*J2*g*m1*m2*s1*sin(phi1) - d0*l1*m2^2*s2^2*x0_p*cos(phi1 - 2*phi2) + m1^2*m2*phi1_p^2*s1^2*s2^2*sin(2*phi1) - g*l1*m0*m2^2*s2^2*sin(phi1 - 2*phi2) - g*l1*m1*m2^2*s2^2*sin(phi1 - 2*phi2) + g*m1*m2^2*s1*s2^2*sin(phi1 - 2*phi2) + m1*m2^2*phi2_p^2*s1*s2^3*sin(phi1 + phi2) + l1^2*m0*m2^2*phi1_p^2*s2^2*sin(2*phi1 - 2*phi2) + l1^2*m1*m2^2*phi1_p^2*s2^2*sin(2*phi1 - 2*phi2) - d2*l1*m2^2*phi1_p*s2*cos(phi1 + phi2) + d2*l1*m2^2*phi2_p*s2*cos(phi1 + phi2) - 2*F*m1*m2*s1*s2^2*cos(phi1) + 2*l1*m0*m2^2*phi2_p^2*s2^3*sin(phi1 - phi2) + 2*l1*m1*m2^2*phi2_p^2*s2^3*sin(phi1 - phi2) - m1*m2^2*phi2_p^2*s1*s2^3*sin(phi1 - phi2) + J2*l1*m2^2*phi2_p^2*s2*sin(phi1 + phi2) + d2*l1*m2^2*phi1_p*s2*cos(phi1 - phi2) - d2*l1*m2^2*phi2_p*s2*cos(phi1 - phi2) + 2*d0*m1*m2*s1*s2^2*x0_p*cos(phi1) - 2*g*m0*m1*m2*s1*s2^2*sin(phi1) + 2*J2*l1*m0*m2*phi2_p^2*s2*sin(phi1 - phi2) + 2*J2*l1*m1*m2*phi2_p^2*s2*sin(phi1 - phi2) - J2*m1*m2*phi2_p^2*s1*s2*sin(phi1 - phi2) + l1*m1*m2^2*phi1_p^2*s1*s2^2*sin(2*phi1) + 2*J2*l1*m1*m2*phi1_p^2*s1*sin(2*phi1) - l1*m1*m2^2*phi1_p^2*s1*s2^2*sin(2*phi1 - 2*phi2) - d2*m1*m2*phi1_p*s1*s2*cos(phi1 + phi2) + d2*m1*m2*phi2_p*s1*s2*cos(phi1 + phi2) + J2*m1*m2*phi2_p^2*s1*s2*sin(phi1 + phi2) + 2*d2*l1*m0*m2*phi1_p*s2*cos(phi1 - phi2) - 2*d2*l1*m0*m2*phi2_p*s2*cos(phi1 - phi2) + 2*d2*l1*m1*m2*phi1_p*s2*cos(phi1 - phi2) - 2*d2*l1*m1*m2*phi2_p*s2*cos(phi1 - phi2) - d2*m1*m2*phi1_p*s1*s2*cos(phi1 - phi2) + d2*m1*m2*phi2_p*s1*s2*cos(phi1 - phi2))/(J2*l1^2*m2^2 + J2*m1^2*s1^2 + J1*m2^2*s2^2 + 2*J1*J2*m0 + 2*J1*J2*m1 + 2*J1*J2*m2 + l1^2*m0*m2^2*s2^2 + l1^2*m1*m2^2*s2^2 + m1*m2^2*s1^2*s2^2 + m1^2*m2*s1^2*s2^2 + 2*J2*l1^2*m0*m2 + 2*J2*l1^2*m1*m2 + 2*J2*m0*m1*s1^2 + 2*J1*m0*m2*s2^2 + 2*J1*m1*m2*s2^2 + 2*J2*m1*m2*s1^2 - J2*l1^2*m2^2*cos(2*phi1) - J2*m1^2*s1^2*cos(2*phi1) - J1*m2^2*s2^2*cos(2*phi2) - l1*m1*m2^2*s1*s2^2 + 2*m0*m1*m2*s1^2*s2^2 - 2*J2*l1*m1*m2*s1 - m1^2*m2*s1^2*s2^2*cos(2*phi1) - m1*m2^2*s1^2*s2^2*cos(2*phi2) - l1^2*m0*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1^2*m1*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1*m1*m2^2*s1*s2^2*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi2) - 2*J2*l1*m1*m2*s1*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi1 - 2*phi2));
    f6 = (d2*l1^2*m2^2*phi1_p - d2*l1^2*m2^2*phi2_p + d2*m1^2*phi1_p*s1^2 - d2*m1^2*phi2_p*s1^2 + 2*J1*d2*m0*phi1_p - 2*J1*d2*m0*phi2_p + 2*J1*d2*m1*phi1_p - 2*J1*d2*m1*phi2_p + 2*J1*d2*m2*phi1_p - 2*J1*d2*m2*phi2_p - d2*m1^2*phi1_p*s1^2*cos(2*phi1) + d2*m1^2*phi2_p*s1^2*cos(2*phi1) - F*l1^2*m2^2*s2*cos(2*phi1 - phi2) + 2*J1*g*m2^2*s2*sin(phi2) - J1*m2^2*phi2_p^2*s2^2*sin(2*phi2) + F*l1^2*m2^2*s2*cos(phi2) + 2*F*J1*m2*s2*cos(phi2) + 2*d2*l1^2*m0*m2*phi1_p - 2*d2*l1^2*m0*m2*phi2_p + 2*d2*l1^2*m1*m2*phi1_p - 2*d2*l1^2*m1*m2*phi2_p + 2*d2*m0*m1*phi1_p*s1^2 - 2*d2*m0*m1*phi2_p*s1^2 + 2*d2*m1*m2*phi1_p*s1^2 - 2*d2*m1*m2*phi2_p*s1^2 - d2*l1^2*m2^2*phi1_p*cos(2*phi1) + d2*l1^2*m2^2*phi2_p*cos(2*phi1) - d0*l1^2*m2^2*s2*x0_p*cos(phi2) + g*l1^2*m0*m2^2*s2*sin(phi2) + g*l1^2*m1*m2^2*s2*sin(phi2) + 2*g*m1*m2^2*s1^2*s2*sin(phi2) + g*m1^2*m2*s1^2*s2*sin(phi2) + J1*l1*m2^2*phi1_p^2*s2*sin(phi1 - phi2) - 2*J1*d0*m2*s2*x0_p*cos(phi2) + 2*J1*g*m0*m2*s2*sin(phi2) + 2*J1*g*m1*m2*s2*sin(phi2) - m1*m2^2*phi2_p^2*s1^2*s2^2*sin(2*phi2) - m1^2*m2*phi1_p^2*s1^3*s2*sin(phi1 + phi2) + l1^2*m0*m2^2*phi2_p^2*s2^2*sin(2*phi1 - 2*phi2) + l1^2*m1*m2^2*phi2_p^2*s2^2*sin(2*phi1 - 2*phi2) - d1*l1*m2^2*phi1_p*s2*cos(phi1 + phi2) - d2*l1*m2^2*phi1_p*s2*cos(phi1 + phi2) + d2*l1*m2^2*phi2_p*s2*cos(phi1 + phi2) + 2*F*m1*m2*s1^2*s2*cos(phi2) + d0*l1^2*m2^2*s2*x0_p*cos(2*phi1 - phi2) - g*l1^2*m0*m2^2*s2*sin(2*phi1 - phi2) - g*l1^2*m1*m2^2*s2*sin(2*phi1 - phi2) + g*m1^2*m2*s1^2*s2*sin(2*phi1 - phi2) + 2*l1^3*m0*m2^2*phi1_p^2*s2*sin(phi1 - phi2) + 2*l1^3*m1*m2^2*phi1_p^2*s2*sin(phi1 - phi2) - m1^2*m2*phi1_p^2*s1^3*s2*sin(phi1 - phi2) - J1*l1*m2^2*phi1_p^2*s2*sin(phi1 + phi2) + d1*l1*m2^2*phi1_p*s2*cos(phi1 - phi2) + d2*l1*m2^2*phi1_p*s2*cos(phi1 - phi2) - d2*l1*m2^2*phi2_p*s2*cos(phi1 - phi2) - 2*d2*l1*m1*m2*phi1_p*s1 + 2*d2*l1*m1*m2*phi2_p*s1 - 2*d2*l1*m1*m2*phi1_p*s1*cos(2*phi1) + 2*d2*l1*m1*m2*phi2_p*s1*cos(2*phi1) + l1*m1*m2^2*phi1_p^2*s1^2*s2*sin(phi1 - phi2) + l1*m1^2*m2*phi1_p^2*s1^2*s2*sin(phi1 - phi2) - 3*l1^2*m1*m2^2*phi1_p^2*s1*s2*sin(phi1 - phi2) - 2*d0*m1*m2*s1^2*s2*x0_p*cos(phi2) - F*l1*m1*m2*s1*s2*cos(2*phi1 - phi2) - 3*g*l1*m1*m2^2*s1*s2*sin(phi2) - g*l1*m1^2*m2*s1*s2*sin(phi2) + 2*g*m0*m1*m2*s1^2*s2*sin(phi2) + 2*J1*l1*m0*m2*phi1_p^2*s2*sin(phi1 - phi2) + 2*J1*l1*m1*m2*phi1_p^2*s2*sin(phi1 - phi2) - J1*m1*m2*phi1_p^2*s1*s2*sin(phi1 - phi2) + l1*m1*m2^2*phi2_p^2*s1*s2^2*sin(2*phi2) - l1*m1*m2^2*phi2_p^2*s1*s2^2*sin(2*phi1 - 2*phi2) - d1*m1*m2*phi1_p*s1*s2*cos(phi1 + phi2) - d2*m1*m2*phi1_p*s1*s2*cos(phi1 + phi2) + d2*m1*m2*phi2_p*s1*s2*cos(phi1 + phi2) - F*l1*m1*m2*s1*s2*cos(phi2) + g*l1*m1*m2^2*s1*s2*sin(2*phi1 - phi2) - g*l1*m1^2*m2*s1*s2*sin(2*phi1 - phi2) - l1*m1*m2^2*phi1_p^2*s1^2*s2*sin(phi1 + phi2) + l1*m1^2*m2*phi1_p^2*s1^2*s2*sin(phi1 + phi2) + l1^2*m1*m2^2*phi1_p^2*s1*s2*sin(phi1 + phi2) - J1*m1*m2*phi1_p^2*s1*s2*sin(phi1 + phi2) + 2*d1*l1*m0*m2*phi1_p*s2*cos(phi1 - phi2) + 2*d1*l1*m1*m2*phi1_p*s2*cos(phi1 - phi2) + 2*d2*l1*m0*m2*phi1_p*s2*cos(phi1 - phi2) - 2*d2*l1*m0*m2*phi2_p*s2*cos(phi1 - phi2) + 2*d2*l1*m1*m2*phi1_p*s2*cos(phi1 - phi2) - 2*d2*l1*m1*m2*phi2_p*s2*cos(phi1 - phi2) - d1*m1*m2*phi1_p*s1*s2*cos(phi1 - phi2) - d2*m1*m2*phi1_p*s1*s2*cos(phi1 - phi2) + d2*m1*m2*phi2_p*s1*s2*cos(phi1 - phi2) + 2*l1*m0*m1*m2*phi1_p^2*s1^2*s2*sin(phi1 - phi2) + d0*l1*m1*m2*s1*s2*x0_p*cos(phi2) - g*l1*m0*m1*m2*s1*s2*sin(phi2) + d0*l1*m1*m2*s1*s2*x0_p*cos(2*phi1 - phi2) - g*l1*m0*m1*m2*s1*s2*sin(2*phi1 - phi2))/(J2*l1^2*m2^2 + J2*m1^2*s1^2 + J1*m2^2*s2^2 + 2*J1*J2*m0 + 2*J1*J2*m1 + 2*J1*J2*m2 + l1^2*m0*m2^2*s2^2 + l1^2*m1*m2^2*s2^2 + m1*m2^2*s1^2*s2^2 + m1^2*m2*s1^2*s2^2 + 2*J2*l1^2*m0*m2 + 2*J2*l1^2*m1*m2 + 2*J2*m0*m1*s1^2 + 2*J1*m0*m2*s2^2 + 2*J1*m1*m2*s2^2 + 2*J2*m1*m2*s1^2 - J2*l1^2*m2^2*cos(2*phi1) - J2*m1^2*s1^2*cos(2*phi1) - J1*m2^2*s2^2*cos(2*phi2) - l1*m1*m2^2*s1*s2^2 + 2*m0*m1*m2*s1^2*s2^2 - 2*J2*l1*m1*m2*s1 - m1^2*m2*s1^2*s2^2*cos(2*phi1) - m1*m2^2*s1^2*s2^2*cos(2*phi2) - l1^2*m0*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1^2*m1*m2^2*s2^2*cos(2*phi1 - 2*phi2) - l1*m1*m2^2*s1*s2^2*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi2) - 2*J2*l1*m1*m2*s1*cos(2*phi1) + l1*m1*m2^2*s1*s2^2*cos(2*phi1 - 2*phi2));
end

ode = [f1; f2; f3; f4; f5; f6];
x = [ x0, phi1, phi2, x0_p, phi1_p, phi2_p ];
u = F;

end
