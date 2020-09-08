function syslin = Linearisierung(sys,AP)
% Linerisiert das gegebene System um den Arbeitspunkt und konvertiert auf numerische Werte

syslin = linSys(sys, AP.x, AP.u); % Angabe von u macht keinen Unterschied. Weil Eingangsaffin?
syslin.A = double(syslin.A);
syslin.B = double(syslin.B);
syslin.C = double(syslin.C);
syslin.D = double(syslin.D);

end