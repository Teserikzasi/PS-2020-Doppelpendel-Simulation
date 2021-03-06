function [eqSolved, eqCoupled] = SchlittenPendelSymF()
% Symbolische Berechnung des Schlitten-Doppelpendel-Systems mithilfe der Lagrange-Gleichungen

%% Variablen

% Eingänge
syms  F  real;

% Minimal-Koordinaten
syms  x0 phi1 phi2  x0_p phi1_p phi2_p  x0_pp phi1_pp phi2_pp  real;
q = { x0, phi1, phi2, x0_p, phi1_p, phi2_p, x0_pp, phi1_pp, phi2_pp };
qt  = str2sym({ 'x0(t)', 'phi1(t)', 'phi2(t)', ...
    'diff(x0(t))', 'diff(phi1(t))', 'diff(phi2(t))', ...
    'diff(x0(t),2)', 'diff(phi1(t),2)', 'diff(phi2(t),2)' });


%% Parameter

syms  m0 m1 m2  J1 J2  l1 l2  s1 s2  d0 d1 d2 ...
     Fc0 Mc10 Mc20 x0_p_c076 phi1_p_c076 phi2_p_c076  g  positive;


%% Kinematik

% Koordinaten
x1 = x0 - s1*sin(phi1);
y1 =      s1*cos(phi1);
x2 = x0 - l1*sin(phi1) - s2*sin(phi2);
y2 =      l1*cos(phi1) + s2*cos(phi2);

% Zeit-Ableitung + Umformung zurück zu Variablen
x1_p = subs( diff(subs(x1,q,qt)) ,qt,q);
y1_p = subs( diff(subs(y1,q,qt)) ,qt,q);
x2_p = subs( diff(subs(x2,q,qt)) ,qt,q);
y2_p = subs( diff(subs(y2,q,qt)) ,qt,q);


%% Mechanik

% Kinetische und potentielle Energie
T = 1/2*m0*x0_p^2 + 1/2*m1*(x1_p^2+y1_p^2) + 1/2*m2*(x2_p^2+y2_p^2) + ...
    1/2*J1*phi1_p^2 + 1/2*J2*phi2_p^2;

U = g*m1*y1 + g*m2*y2;

L = T-U;

% viskose Dämpfung
Fd  = -d0 * x0_p;
Md1 = -d1 * phi1_p;
Md2 = -d2 * (phi2_p-phi1_p);

% Coulomb-Kräfte
Fc  = -Fc0  * tanh(x0_p/x0_p_c076); %2/pi*atan(x0_p/x0_p_c2); %sign(x0_p);
Mc1 = -Mc10 * tanh(phi1_p/phi1_p_c076); %2/pi*atan(phi1_p/phi1_p_c2);
Mc2 = -Mc20 * tanh((phi2_p-phi1_p)/phi2_p_c076); %2/pi*atan((phi2_p-phi1_p)/phi2_p_c2);

% Nicht-konservative Kräfte
Q0 = F + Fd + Fc;
Q1 = Md1 + Mc1 - Md2 - Mc2;
Q2 = Md2 + Mc2;


%% Ableitung nach generalisierten Koordinaten

L_x0   = jacobian(L,x0);
L_phi1 = jacobian(L,phi1);
L_phi2 = jacobian(L,phi2);

L_x0_p   = jacobian(L,x0_p);
L_phi1_p = jacobian(L,phi1_p);
L_phi2_p = jacobian(L,phi2_p);

L_x0_p_t   = subs( diff( subs(L_x0_p,  q,qt)), qt,q);
L_phi1_p_t = subs( diff( subs(L_phi1_p,q,qt)), qt,q);
L_phi2_p_t = subs( diff( subs(L_phi2_p,q,qt)), qt,q);


%% Berechnung der LAGRANGEschen Gleichung

eqCoupled = [L_x0_p_t-L_x0 == Q0; L_phi1_p_t-L_phi1 == Q1; L_phi2_p_t-L_phi2 == Q2];
Sol = solve( eqCoupled , [x0_pp, phi1_pp, phi2_pp ] );%, 'ReturnConditions', true 
%Sol.conditions

eqSolved = [simplify(Sol.x0_pp);  simplify(Sol.phi1_pp);  simplify(Sol.phi2_pp) ];

end