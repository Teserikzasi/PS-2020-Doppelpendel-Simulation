function sys = SchlittenPendelNLZSR_Fauve(equations,parameter,eingang)
% SchlittenPendelNLZSR erstellt ein Zustandsraummodell, das so strukturiert ist,
% dass dieses anschließend mit sys2sfct in eine S-Function transformiert
% werden kann. Sie bekommt die symbolischen DGL des Systems sowie eine
% Struktur mit den benötigten Parameter übergeben.

sys.name = ['SchlittenPendel NLZSR (' eingang ')' ];
sys.desc = ['Nichtlineare Zustandsraumdarstellung des Schlitten-Doppelpendel-Systems ' ...
            '(Eingang: ' eingang ' )' ];

u = {eingang};
x = {'x1' 'x2' 'x3' 'x4' 'x5' 'x6' };
y = {'x1' 'x3' 'x5' };
p = {'m0' 'm1' 'm2' 'J1' 'J2' 'l1' 'l2' 's1' 's2' 'd0' 'd1' 'd2' 'g'}; 

sys.u.var = u;
sys.u.name = u;
sys.x.var = x;
sys.x.name = x;
sys.y.name = y;
sys.p.var = p;
sys.p.name = p;

sys.f = ['x2'; equations(1); 'x4'; equations(2); 'x6'; equations(3) ];
sys.h = [str2sym({'x1'; 'x3'; 'x5' }) ];

% Ersetze Symbole in equations durch Parameter
if ~isempty(parameter)
		sys = setSysParam(sys, parameter);
end

end
