%function Auswertung(out, save, name, path)

plot_outputs(out)%, save, name, path)
animate_outputs(out)%,[], save, name, path)
%path = 'Plots';
%name = 'motor sättigung u=2';
%plot_outputs(out,true,name,path)
%animate_outputs(out,SchlittenPendelParams,true,name,path)

if any(out.MotorSatState.Data)
    disp("Motor in Sättigung!")
end

%end