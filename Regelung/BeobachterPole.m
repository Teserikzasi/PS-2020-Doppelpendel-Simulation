function pole = BeobachterPole(regPole)
% Liefert die Pole des Beobachters (evtl in Abhängigkeit der Pole des
% geschlossenen Regelkreises)

    %pole = regPole - 25;  % Chang19
    %pole = real(regPole) - 25;  % besser
    %pole = regPole*5;  % schlecht
    pole = real(regPole*5);  % besser
    %pole = real(regPole*8);
    %pole = regPole*0 - 25;  % The "place" command cannot place poles with multiplicity greater than rank(B).
    %pole = [-25, -26, -27, -28, -29, -30];
    %pole = [-40, -41, -42, -43, -44, -45];  % Brehl14
end

