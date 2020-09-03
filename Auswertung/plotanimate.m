function plotanimate(out, name, path)
% plot und animate, optional mit speichern
% path relativ zu Plots
global MotorParams
global SchlittenPendelParams
speedFactor = 1;


if nargin==1
    plot_outputs(out)
    animate_outputs(out)
elseif nargin==2
    plot_outputs(out,MotorParams,true,name)
    animate_outputs(out,SchlittenPendelParams,speedFactor,true,name)
else
    plot_outputs(out,MotorParams,true,name,path)
    animate_outputs(out,SchlittenPendelParams,speedFactor,true,name,path)
end

end