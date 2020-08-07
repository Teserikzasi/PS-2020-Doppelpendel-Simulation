function [eqSolved, eqCoupled] = SchlittenPendelSymA()

% Eingänge
syms a real;

[eqSolvedF, eqCoupledF] = SchlittenPendelSymF();

eqCoupled = [str2sym('x0_pp=a'); eqCoupledF(2); eqCoupledF(3)];

Sol = solve( eqCoupled , {'x0_pp', 'phi1_pp', 'phi2_pp' } );

eqSolved = [simplify(Sol.x0_pp);  simplify(Sol.phi1_pp);  simplify(Sol.phi2_pp) ];

end