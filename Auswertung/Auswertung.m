function Auswertung(out)
% Allgemeine Auswertung einer Simulation

global SchlittenPendelParams

if any(out.outofcontrol.Data)
    t0 = out.outofcontrol.Time(find(out.outofcontrol.Data,1));
    fprintf('System außer Kontrolle:  t = %.3f\n', t0 )
end

if any(out.mY.Data(1,1,:) > SchlittenPendelParams.x0_max) || ...
   any(out.mY.Data(1,1,:) < SchlittenPendelParams.x0_min)
    disp("Schlitten außerhalb der Begrenzung!")
end

if ismember('MotorSat_I', out.who)
    if any(out.MotorSat_I.Data)
        disp("Motor in Stellgrößenbegrenzung! (Soll Strom > max Strom)")
    end
end

if ismember('MotorSat_w', out.who)
    if any(out.MotorSat_w.Data)
        disp("Motor in Sättigung! (kein max Strom möglich)")
    end
end

if ismember('satState_u', out.who)
    if any(out.satState_u.Data)
        disp("Regler in Stellgrößenbegrenzung! (Motorspannung begrenzt)")
    end
end

end