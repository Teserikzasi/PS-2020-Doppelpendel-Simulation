function RegData = AP_RegData_calc(sys, APs, riccdata )
% Linearisiert alle Arbeitspunkte des nichtlinearen Systems und 
% berechnet Regler und Beobachter für gegebene Werte

for i=1:4
    syslin = Linearisierung(sys, APs(i));
    syslin.name = ['SchlittenPendel AP' int2str(i)];
    syslin.desc = ['Linearisierte Zustandsraumdarstellung des Schlitten-Doppelpendel-Systems ' ...
        '(Arbeitspunkt ' int2str(i) ')' ];
    [K, regPole] = LQRegler(syslin, riccdata(i));
    beobPole = BeobachterPole(regPole);
    L = PlaceBeobachter(syslin, beobPole);
    
    RegData(i) = struct('K', K, 'regPole', regPole, 'L', L, 'beobPole', beobPole, ...
        'syslin', syslin, 'riccdata', riccdata(i) );
end

end