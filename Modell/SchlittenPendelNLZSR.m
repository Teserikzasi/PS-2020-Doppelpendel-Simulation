function sys = SchlittenPendelNLZSR(equations,parameter)
% SchlittenPendelNLZSR erstellt ein Zustandsraummodell, das so strukturiert ist,
% dass dieses anschließend mit sys2sfct in eine S-Function transformiert
% werden kann. Sie bekommt die symbolischen DGL des Systems sowie eine
% Struktur mit den benötigten Parameter übergeben.

u = {'F'};
x = {'x0' 'x0_p' 'phi1' 'phi1_p' 'phi2' 'phi2_p' };
y = {'x0' 'phi1' 'phi2' };
p = {'m0' 'm1' 'm2' 'l1' 'l2' 'J1' 'J2' 's1' 's2' 'd0' 'd1' 'd2' 'g'};

sys.u.var = u;
sys.u.name = u;
sys.x.var = x;
sys.x.name = x;
sys.y.name = y;
sys.p.var = p;
sys.p.name = p; 

%syms m0 m1 m2 l1 l2 J1 J2 s1 s2 d0 d1 d2 g positive;
%equations = subs(equations,[m0 m1 m2  l1 l2  J1 J2  s1 s2  d0 d1 d2  g],ones(1,13))
sys.f = ['x0_p'; equations(1); 'phi1_p'; equations(2); 'phi2_p'; equations(3) ];
sys.h = str2sym({'x0'; 'phi1'; 'phi2' });

% Ersetze  Symbole in equations durch Parameter
if ~isempty(parameter)
		sys = setSysParam(sys, parameter);
end

sys.name = 'SchlittenPendelNLZSR';
sys.desc = 'Nichtlineare Zustandsraumdarstellung des Schlitten-Doppelpendel-Systems';

end