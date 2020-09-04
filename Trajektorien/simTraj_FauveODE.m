function simout = simTraj_FauveODE(u_traj, N, T, x_init)
% Simuliere Trajektorie am Fauve-Modell
% ACHTUNG: Überschreibt Systemgleichungen! (-->Siminit neu ausführen)

global simparams
global SchlittenPendelParams
global equationsF
global sysF

t = 0: T :(length(u_traj)-1)*T;
u_sim = timeseries(u_traj, t, 'Name', 'F_steuer'); 

SchlittenPendelParams = SchlittenPendelParams_Apprich09();
syms x1 x2 x3 x4 x5 x6 u
syms  m0 m1 m2  J1 J2  l1 l2  s1 s2  d0 d1 d2 g  positive;
equationsF(1) = ((m2*s2^2 + J2)*(l1*m2 + m1*s1)*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)) + (m2*s2^2 + J2)*(m2*l1^2 + m1*s1^2 + J1)*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2) + m1*s2*cos(x5)*(m2*l1^2 + m1*s1^2 + J1)*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)) - l1^2*m2^2*s2^2*cos(x3 - x5)^2*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2) - l1*m2*s2*cos(x3 - x5)*(l1*m2 + m1*s1)*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)) - l1*m1*m2*s2^2*cos(x3 - x5)*cos(x5)*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)))/((m2*s2^2 + J2)*(m0 + m1 + m2)*(m2*l1^2 + m1*s1^2 + J1) - cos(x3)*(m2*s2^2 + J2)*(l1*m2 + m1*s1)^2 - m1*m2*s2^2*cos(x5)^2*(m2*l1^2 + m1*s1^2 + J1) - l1^2*m2^2*s2^2*cos(x3 - x5)^2*(m0 + m1 + m2) + l1*m2^2*s2^2*cos(x3 - x5)*cos(x5)*(l1*m2 + m1*s1) + l1*m1*m2*s2^2*cos(x3 - x5)*cos(x3)*cos(x5)*(l1*m2 + m1*s1));
equationsF(2) = ((m2*s2^2 + J2)*(m0 + m1 + m2)*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)) + cos(x3)*(m2*s2^2 + J2)*(l1*m2 + m1*s1)*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2) - m1*m2*s2^2*cos(x5)^2*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)) - l1*m2^2*s2^2*cos(x3 - x5)*cos(x5)*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2) - l1*m2*s2*cos(x3 - x5)*(m0 + m1 + m2)*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)) + m1*s2*cos(x3)*cos(x5)*(l1*m2 + m1*s1)*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)))/((m2*s2^2 + J2)*(m0 + m1 + m2)*(m2*l1^2 + m1*s1^2 + J1) - cos(x3)*(m2*s2^2 + J2)*(l1*m2 + m1*s1)^2 - m1*m2*s2^2*cos(x5)^2*(m2*l1^2 + m1*s1^2 + J1) - l1^2*m2^2*s2^2*cos(x3 - x5)^2*(m0 + m1 + m2) + l1*m2^2*s2^2*cos(x3 - x5)*cos(x5)*(l1*m2 + m1*s1) + l1*m1*m2*s2^2*cos(x3 - x5)*cos(x3)*cos(x5)*(l1*m2 + m1*s1));
equationsF(3) = -(cos(x3)*(l1*m2 + m1*s1)^2*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)) - (m0 + m1 + m2)*(m2*l1^2 + m1*s1^2 + J1)*(l1*m2*s2*sin(x3 - x5)*x4^2 + d2*x4 - d2*x6 + g*m2*s2*sin(x5)) - m2*s2*cos(x5)*(m2*l1^2 + m1*s1^2 + J1)*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2) - m2*s2*cos(x5)*(l1*m2 + m1*s1)*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)) + l1*m2*s2*cos(x3 - x5)*(m0 + m1 + m2)*(- l1*m2*s2*sin(x3 - x5)*x6^2 + d2*x6 - x4*(d1 + d2) + g*sin(x3)*(l1*m2 + m1*s1)) + l1*m2*s2*cos(x3 - x5)*cos(x3)*(l1*m2 + m1*s1)*(sin(x3)*(l1*m2 + m1*s1)*x4^2 - m2*s2*sin(x5)*x6^2 + u - d0*x2))/((m2*s2^2 + J2)*(m0 + m1 + m2)*(m2*l1^2 + m1*s1^2 + J1) - cos(x3)*(m2*s2^2 + J2)*(l1*m2 + m1*s1)^2 - m1*m2*s2^2*cos(x5)^2*(m2*l1^2 + m1*s1^2 + J1) - l1^2*m2^2*s2^2*cos(x3 - x5)^2*(m0 + m1 + m2) + l1*m2^2*s2^2*cos(x3 - x5)*cos(x5)*(l1*m2 + m1*s1) + l1*m1*m2*s2^2*cos(x3 - x5)*cos(x3)*cos(x5)*(l1*m2 + m1*s1));
sysF = SchlittenPendelNLZSR_Fauve(equationsF, SchlittenPendelParams, 'u');
sys2sfct(sysF,'SchlittenPendelFunc','M','Path','Modell');

simparams.F_traj = u_sim; % Trajektorie
SchlittenPendelParams.x0 = x_init; % Anfangswerte

simparams.gesamtmodell.schlittenpendel = SchlittenPendelParams;
tsim = N*T;

%simout = sim('Trajektorien_test', tsim);
simout = sim('Modell\Trajektorien_test', tsim);
end

