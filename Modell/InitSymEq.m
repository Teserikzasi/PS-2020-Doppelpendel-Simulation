
% Berechne symbolische DGL des Schlittenpendels

global equationsF
global equationsA
equationsF = SchlittenPendelSymF();
equationsA = SchlittenPendelSymA();
disp('Symbolische Systemgleichungen des Schlittenpendels berechnet')

global Ruhelagen
Ruhelagen = SchlittenPendelRuhelagen();
