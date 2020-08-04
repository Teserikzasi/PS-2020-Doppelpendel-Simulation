function [eqSolved, eqCoupled] = SchlittenPendelSymA()

% Eingänge
syms a real;

[eqSolved, eqCoupled] = SchlittenPendelSymF();

Sol = solve( [str2sym('x0_pp=a'); eqCoupled(2); eqCoupled(3)] , {'x0_pp', 'phi1_pp', 'phi2_pp' } );

eqSolved = [simplify(Sol.x0_pp);  simplify(Sol.phi1_pp);  simplify(Sol.phi2_pp) ];

end