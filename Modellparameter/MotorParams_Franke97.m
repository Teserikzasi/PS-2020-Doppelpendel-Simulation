function stM = MotorParams_Franke97()
    % Gibt alle relevanten Parameter von Motor und Getriebe zurück nach [Franke 1997].
    %
    % Hinweis: Bei Hinzufügen neuer Parameter sollten diese sinnvollerweise auch in der Maske
    % des Motormodells in Simulink hinzugefügt werden.
    
    %% V/A Wandler
    stM.Umax_in = 10; % max. Steuerspannung [+-V]
    stM.K_UI = 1.87; % V/A Wandler: Verstärkungsfaktor, am Wandler theoretisch einstellbar bis K_UI = 2 A/V
    stM.T_UI = 0.00075; % V/A Wandler: Zeitkonstante
    stM.Imax = stM.Umax_in*stM.K_UI; % Impulsstrom [+-A] (für K_UI=2 max 4 sec.)
    stM.Umax_out = 65; % Maximalspannung  [+-V]
    
    %% Motor
    stM.K_I = 0.153; % Drehmomentkonstante
    stM.J_MG = 0.000216; % Massenträgheitsmoment Motor und Getriebe
    stM.R = 0.9; % Ankerwiderstand  
    
    %% Getriebe
    stM.K_G = 16/60; % Getriebeübersetzung
    stM.r32 = 0.0255; % Radius von Drehachse des Antriebsrads zur neutralen Phase des Antriebsriemens

    %% Reibungskonstanten
    stM.d0_MG = 0.052; % konstante Reibung in Nm
    stM.dw_MG = 0.0000574; % geschwindigkeitsabhängige Reibung in Nm/(rad/s)
    
    %% statische Verstärkung u->F
    stM.staticGain = stM.K_UI*stM.K_I/stM.K_G/stM.r32; 
    stM.Fmax = stM.Umax_in*stM.staticGain;
end