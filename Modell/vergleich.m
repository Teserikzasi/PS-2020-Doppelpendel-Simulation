% Vergleich mit alter manuell berechneter Gleichung
eq = SchlittenPendelSymF()
eq = subs(eq,'Fc0',0);
eq = subs(eq,'Mc10',0);
eq = subs(eq,'Mc20',0);
eq = simplify(eq)

DP = getDPendulumF
dpf=subs(DP.f,str2sym({'x1','x2','x3','x4','x5','x6','u'}),str2sym({'x0', 'x0_p','phi1','phi1_p', 'phi2', 'phi2_p','F'}))

dpf - ['x0_p'; eq(1); 'phi1_p'; eq(2); 'phi2_p'; eq(3) ]
simplify(ans) % ungleich 0
 %Parameter setzen hilft auch nicht

%PendulumA stimmt überein