function Auswertung(out)
% Allgemeine Auswertung einer Simulation

if any(out.outofcontrol.Data)
    t0 = out.outofcontrol.Time(find(out.outofcontrol.Data,1));
    fprintf('System außer Kontrolle:  t = %.3f\n', t0 )
end

if any(out.MotorSat_I.Data)
    disp("Motor in Stellgrößenbegrenzung! (Soll Strom > max Strom)")
end

if any(out.MotorSat_w.Data)
    disp("Motor in Sättigung! (kein max Strom möglich)")
end

if any(out.satState_u.Data)
    disp("Regler in Stellgrößenbegrenzung! (Motorspannung begrenzt)")
end

end