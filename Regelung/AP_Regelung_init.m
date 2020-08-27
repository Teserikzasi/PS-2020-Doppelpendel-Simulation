function RegData = AP_Regelung_init(sys, APs, riccdata )
% Linearisiert alle Arbeitspunkte und berechnet Regler und Beobachter für
% gegebene Werte

for i=1:4
    syslin = Linearisierung(sys, APs(i));
    syslin.name = ['SchlittenPendel AP' int2str(i)];
    syslin.desc = ['Linearisierte Zustandsraumdarstellung des Schlitten-Doppelpendel-Systems ' ...
        '(Arbeitspunkt ' int2str(i) ')' ];
    [K, regPole] = LQRegler(syslin, riccdata(i));
    beobPole = BeobachterPole(regPole);
    L = PlaceBeobachter(syslin, beobPole);
    kpv = 150;
    
    RegData(i) = struct('K', K, 'regPole', regPole, 'L', L, 'beobPole', beobPole, ...
        'syslin', syslin, 'kpv', kpv, 'riccdata', riccdata(i) );
end

end