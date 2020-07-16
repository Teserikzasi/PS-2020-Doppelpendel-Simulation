function RegData = AP_Regelung_init(sys, APs, riccdata, beobPole)
% Linearisiert alle Arbeitspunkte und berechnet Regler und Beobachter für
% gegebene Werte

for i=1:4
    syslin = Linearisierung(sys, APs(i));
    [K, pole] = LQRegler(syslin, riccdata(i));
    L = PlaceBeobachter(syslin, beobPole(i));
    
    RegData(i) = struct('K', K, 'pole', pole, 'L', L );
end

end