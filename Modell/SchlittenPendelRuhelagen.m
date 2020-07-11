function RL = SchlittenPendelRuhelagen(x0)
% Definiert die Ruhelagen/Arbeitspunkte des Schlitten-Doppelpendel-Systems.
% Aufsteigend von unten nach oben

if ~exist('x0')
    x0=0;
end

u=0;

RL(1) = struct('u',u, 'x', [x0 0 pi 0 pi 0] );
RL(2) = struct('u',u, 'x', [x0 0 pi 0 0  0] );
RL(3) = struct('u',u, 'x', [x0 0 0  0 pi 0] );
RL(4) = struct('u',u, 'x', [x0 0 0  0 0  0] );

end