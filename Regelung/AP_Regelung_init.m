function RegData = AP_Regelung_init(sys, APs, riccdata, beobPole)
% Linearisiert alle Arbeitspunkte und berechnet Regler und Beobachter für
% gegebene Werte

for i=1:4
    syslin = Linearisierung(sys, APs(i));
    syslin.name = ['SchlittenPendel AP' int2str(i)];
    syslin.desc = ['Linearisierte Zustandsraumdarstellung des Schlitten-Doppelpendel-Systems ' ...
        '(Arbeitspunkt ' int2str(i) ')' ];
    [K, pole] = LQRegler(syslin, riccdata(i));
    beobPole = pole - 25;
    L = PlaceBeobachter(syslin, beobPole);
    
    RegData(i) = struct('K', K, 'pole', pole, 'L', L, 'beobPole', beobPole, 'syslin', syslin );
end

end