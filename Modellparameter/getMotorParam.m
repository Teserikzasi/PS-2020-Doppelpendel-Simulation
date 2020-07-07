function stM = getMotorParam()
% Gibt alle relevanten Parameter von Motor und Getriebe zurück.

stM.K_UI = 1.87;
stM.T_UI = 0.00075;
stM.K_I = 0.153;
stM.J_MG = 0.000216;
stM.K_G = 16/60;
stM.r32 = 0.0255;
stM.M = 7.055;

stM.Umin = -10;
stM.Umax = 10;

% Dummy-Werte
stM.Fmax = 421;
stM.Fmin = -421;

end

