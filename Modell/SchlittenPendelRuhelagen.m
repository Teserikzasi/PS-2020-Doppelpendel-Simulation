function RL = SchlittenPendelRuhelagen(x0)
    % Definiert die Ruhelagen/Arbeitspunkte des Schlitten-Doppelpendel-Systems.
    % Aufsteigend von unten nach oben

    if ~exist('x0','var')
        x0=0;
    end

    u=0;

    RL(1) = struct('u', u, 'y', [x0 pi pi]' );
    RL(2) = struct('u', u, 'y', [x0 pi 0 ]' );
    RL(3) = struct('u', u, 'y', [x0 0  pi]' );
    RL(4) = struct('u', u, 'y', [x0 0  0 ]' );

    for i=1:4
        RL(i).i = i;
        y = RL(i).y;
        RL(i).x = [y(1) 0 y(2) 0 y(3) 0]';
    end

end