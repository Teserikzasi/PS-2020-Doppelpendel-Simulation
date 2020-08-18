%function Auswertung(out, name, path)

%path = 'Plots';
%name = 'motor sättigung u=2';
plotanimate(out) %name, path)

if any(out.MotorSat_I.Data)
    disp("Motor in Stellgrößenbegrenzung! (Soll Strom > max Strom)")
end
if any(out.MotorSat_w.Data)
    disp("Motor in Sättigung! (kein max Strom möglich)")
end

%end