
% Berechne symbolische DGL des Schlittenpendels

global equationsF
global equationsA
equationsF = SchlittenPendelSymF();
equationsA = SchlittenPendelSymA();

global Ruhelagen
Ruhelagen = SchlittenPendelRuhelagen();
