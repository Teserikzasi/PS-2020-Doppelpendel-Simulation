% Simuliere Trajektorie am Fauve-Modell
% ACHTUNG: Überschreibt Systemgleichungen! (-->Siminit neu ausführen)

equationsFauve = subs(FauveEquations(), ...
    {'x1','x2','x3','x4','x5','x6'}, {'x0', 'x0_p','phi1','phi1_p', 'phi2', 'phi2_p' } );

sysFauve = SchlittenPendelNLZSR(equationsFauve, SchlittenPendelParams_Apprich09(), 'u');
sysFauve.name = [sysFauve.name  ' Fauve' ];
sys2sfct(sysFauve,'SchlittenPendelFunc','M','Path','Modell');
