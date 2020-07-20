function stP = SchlittenPendelParams_Ribeiro20()
% Gibt Schlittenpendelparameter nach [Ribeiro et al. 2020] zurück

	% Pendeldaten
	stP.name = 'Doppelpendel rtm (Ribeiro)';
	stP.desc = 'Doppelpendel rtm, Ribeiro 2020';

	stP.m1 = 0.8534;
	stP.pdesc.m1 = 'Masse Stab 1';
	stP.punit.m1 = 'kg';
	
	stP.J1 = 0.01128;
	stP.pdesc.J1 = 'Massenträgheitsmoment Stab 1';
	stP.punit.J1 = 'kg m^2';

	stP.l1 = 0.282;
	stP.pdesc.l1 = 'Länge Stab 1';
	stP.punit.l1 = 'm';

	stP.s1 = 0.09373;
	stP.pdesc.s1 = 'Schwerpunktlage Stab 1';
	stP.punit.s1 = 'm';

	stP.d1 = 0.00768;
	stP.pdesc.d1 = 'Viskose Dämpfung Stab 1';
	stP.punit.d1 = 'Nm s rad^-1';

	stP.m2 = 0.3957;  
	stP.pdesc.m2 = 'Masse Stab 2';
	stP.punit.m2 = 'kg';

	stP.J2 = 0.003343;  
	stP.pdesc.J2 = 'Massenträgheitsmoment Stab 2';
	stP.punit.J2 = 'kg m^2';

	stP.l2 = 0.280;
	stP.pdesc.l2 = 'Länge Stab 2';
	stP.punit.l2 = 'm';

	stP.s2 = 0.114254;
	stP.pdesc.s2 = 'Schwerpunktlage Stab 2';
	stP.punit.s2 = 'm';

	stP.d2 = 0.000285;
	stP.pdesc.d2 = 'Viskose Dämpfung Stab 2';
	stP.punit.d2 = 'Nm s rad^-1';
	
	stP.m0 = 16.5;
	stP.pdesc.m0 = 'Masse Schlitten mit Antrieb';
	stP.punit.m0 = 'kg';

	stP.d0 = 17.00; % Wert von Chang19. Bei Ribeiro20 wurde nur Haftreibung bestimmt
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
    
    % Coulombsche Reibung
    stP.Mc1 = 0.0538;
    stP.Mc2 = 0.0000912;
    stP.Fc0 = 13.43; % Ribeiro20 S.32 mittlerer Gesamtwert in Plot abgelesen 
                    % durch Messen bei hoher Skalierung (5N=39,2cm) und Dreisatz
    stP.Fc0alpha = 100;  % Skalierungsparameter für die Annäherung von signum mit atan

end