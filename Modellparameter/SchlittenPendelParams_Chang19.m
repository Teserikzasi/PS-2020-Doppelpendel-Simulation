function stP = SchlittenPendelParams_Chang19()
% Gibt Schlittenpendelparameter nach [Chang et al. 2019] zurück
% Parameter stehen in starkem Widerspruch zu den von Ribeiro20 ermittelten
% Werten für die gleiche Hardware

    % Pendeldaten
	stP.name = 'Doppelpendel rtm (Chang19)';
	stP.desc = 'Doppelpendel rtm, Chang 2019';

	stP.m1 = 0.329;
	stP.pdesc.m1 = 'Masse Stab 1';
	stP.punit.m1 = 'kg';
	
	stP.J1 = 0.01457;
	stP.pdesc.J1 = 'Massenträgheitsmoment Stab 1';
	stP.punit.J1 = 'kg m^2';

	stP.l1 = 0.325 ;
	stP.pdesc.l1 = 'Länge Stab 1';
	stP.punit.l1 = 'm';

	stP.s1 = 0.1425;
	stP.pdesc.s1 = 'Schwerpunktlage Stab 1';
	stP.punit.s1 = 'm';

	stP.d1 = 0.005;
	stP.pdesc.d1 = 'Viskose Dämpfung Stab 1';
	stP.punit.d1 = 'N s rad^-1';

	stP.m2 = 0.3075;  
	stP.pdesc.m2 = 'Masse Stab 2';
	stP.punit.m2 = 'kg';

	stP.J2 = 0.00334;  
	stP.pdesc.J2 = 'Massenträgheitsmoment Stab 2';
	stP.punit.J2 = 'kg m^2';

	stP.l2 = 0.305 ;
	stP.pdesc.l2 = 'Länge Stab 2';
	stP.punit.l2 = 'm';

	stP.s2 = 0.114254; % Ribeiro, da bei Cheng in Ausarbeitung fehlend
	stP.pdesc.s2 = 'Schwerpunktlage Stab 2';
	stP.punit.s2 = 'm';

	stP.d2 = 0.005;
	stP.pdesc.d2 = 'Viskose Dämpfung Stab 2';
	stP.punit.d2 = 'N s rad^-1';
	
	stP.m0 = 16.5;
	stP.pdesc.m0 = 'Masse Schlitten mit Antrieb';
	stP.punit.m0 = 'kg';

	stP.d0 = 17.6; % Im Modell steht 17.
                    % Gemittelter Wert des in den Messungen von Cheng19 (S.66) 
                    % eigentlich stark positions- und richtungsabhängigen d0.
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
    stP.Fc0 = 17.5; % Chang19 S.66, im Modell steht 17
    stP.Mc10 = 0.0538;
    stP.Mc20 = 0.0000912;
    % Skalierungsparameter für die Annäherung von signum mit atan
    % Geschwindigkeit, bei der gerade die Hälfte von Fc0/Mc0 erreicht ist
    stP.x0_p_c2 = 0.01;
    stP.phi1_p_c2 = 0.01;   
    stP.phi2_p_c2 = 0.01;
    
end