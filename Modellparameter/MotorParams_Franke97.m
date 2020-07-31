function stM = MotorParams_Franke97()
    % Gibt alle relevanten Parameter von Motor und Getriebe zurück nach [Franke 1997].
    %
    % Hinweis: Bei Hinzufügen neuer Parameter sollten diese sinnvollerweise auch in der Maske
    % des Motormodells in Simulink hinzugefügt werden.

    stM.K_UI = 1.87; % V/A Wandler: Verstärkungsfaktor
    stM.T_UI = 0.00075; % V/A Wandler: Zeitkonstante
    stM.K_I = 0.153; % Drehmomentkonstante
    stM.J_MG = 0.000216; % Massenträgheitsmoment Motor und Getriebe
    stM.K_G = 16/60; % Getriebeübersetzung
    stM.r32 = 0.0255; % Radius von Drehachse des Antriebsrads zur neutralen Phase des Antriebsriemens

    % Motorreibungskonstanten
    stM.d0_MG = 0.052; % konstante Reibung in Nm
    stM.dw_MG = 0.0000574; % geschwindigkeitsabhängige Reibung in Nm/(rad/s)
    
    % Steuerspannung
    stM.Umin = -10;
    stM.Umax = 10;
    
    % Maximale Stellkraft
    % -> Max. Impustrom ist 20A, Drehmomentkonstante 0,153, Getriebe i=60/16,
    %    Antriebsradius r=0,0255
    % Fmax = 20*0,153*60/16/0,0255 = 420,75 < 421
    stM.Fmin = -421;
    stM.Fmax = 421;

    stM.staticGain = stM.K_UI*stM.K_I/stM.K_G/stM.r32; % statische Verstärkung u->F
end