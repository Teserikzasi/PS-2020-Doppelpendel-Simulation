function stP = SchlittenPendelParams_Apprich09()
% Gibt Schlittenpendelparameter nach [Apprich 2009] und Dämpfungskonstanten nach [Kisner 2011] zurück

	% Pendeldaten
	stP.name = 'Doppelpendel rtm (Apprich & Kisner)';
	stP.desc = 'Doppelpendel rtm, S. Apprich 2009 (Dämpfungen nach Kisner 2011)';

	stP.m1 = 0.615;
	stP.pdesc.m1 = 'Masse Stab 1';
	stP.punit.m1 = 'kg';
	
	stP.J1 = 0.00647;
	stP.pdesc.J1 = 'Massenträgheitsmoment Stab 1';
	stP.punit.J1 = 'kg m^2';

	stP.l1 = 0.2905;
	stP.pdesc.l1 = 'Länge Stab 1';
	stP.punit.l1 = 'm';

	stP.s1 = 0.0775;
	stP.pdesc.s1 = 'Schwerpunktlage Stab 1';
	stP.punit.s1 = 'm';

	stP.d1 = 0.0091;
	stP.pdesc.d1 = 'Viskose Dämpfung Stab 1 nach [Kisner 2011]';
	stP.punit.d1 = 'N s rad^-1';

	stP.m2 = 0.347;  
	stP.pdesc.m2 = 'Masse Stab 2';
	stP.punit.m2 = 'kg';

	stP.J2 = 0.00407;  
	stP.pdesc.J2 = 'Massenträgheitsmoment Stab 2';
	stP.punit.J2 = 'kg m^2';

	stP.l2 = 0.3388;
	stP.pdesc.l2 = 'Länge Stab 2';
	stP.punit.l2 = 'm';

	stP.s2 = 0.146;
	stP.pdesc.s2 = 'Schwerpunktlage Stab 2';
	stP.punit.s2 = 'm';

	stP.d2 = 0.0006905;
	stP.pdesc.d2 = 'Viskose Dämpfung Stab 2 nach [Kisner 2011]';
	stP.punit.d2 = 'N s rad^-1';
	
	stP.m0 = 16.5;
	stP.pdesc.m0 = 'Masse Schlitten mit Antrieb';
	stP.punit.m0 = 'kg';

	stP.d0 = 17.00;
	stP.pdesc.d0 = 'Viskose Dämpfung Schlitten';
	stP.punit.d0 = 'N s m^-1';
	
	stP.g = 9.81;
	stP.pdesc.g = 'Erdbeschleunigung';
	stP.punit.g = 'm s^-2';

	stP.x0_min = -.8;
	stP.pdesc.x0_min = 'Minimale Schlittenposition';
	stP.punit.x0_min = 'm';
	
	stP.x0_max = .8;
	stP.pdesc.x0_max = 'Maximale Schlittenposition';
	stP.punit.x0_max = 'm';
    
    stP.Fc0 = 10;  % DUMMY bitte noch realen Wert einsetzen
    stP.Fc0alpha = 100;  % Skalierungsparameter für die Annäherung von signum mit atan

end