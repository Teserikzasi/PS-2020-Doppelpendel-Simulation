function plotanimate(out, name, path, SchlittenPendelParams)
% plot und animate, optional mit speichern
% path relativ zu Plots
speedFactor = 1;
if ~exist('SchlittenPendelParams', 'var')
    SchlittenPendelParams=[];
end

if nargin==1
    plot_outputs(out)
    animate_outputs(out)
elseif nargin==2
    plot_outputs(out,true,name)
    animate_outputs(out,SchlittenPendelParams,speedFactor,true,name)
else
    plot_outputs(out,true,name,path)
    animate_outputs(out,SchlittenPendelParams,speedFactor,true,name,path)
end

end