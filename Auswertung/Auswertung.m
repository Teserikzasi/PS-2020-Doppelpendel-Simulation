%function Auswertung(out, save, name, path)

plot_outputs(out)%, save, name, path)
animate_outputs(out)%,[], save, name, path)

if any(out.MotorSatState.Data)
    disp("Motor in Sättigung!")
end

%end