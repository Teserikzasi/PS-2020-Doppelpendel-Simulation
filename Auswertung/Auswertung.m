%function Auswertung(out, name, path)

%path = 'Plots';
%name = 'motor sättigung u=2';
plotanimate(out) %name, path)

if any(out.MotorSatState.Data)
    disp("Motor in Sättigung!")
end

%end