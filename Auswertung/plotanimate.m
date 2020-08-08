function plotanimate(out, name, path, SchlittenPendelParams)
% plot und animate, optional mit speichern
% path relativ zu Plots

if ~exist('SchlittenPendelParams')
    SchlittenPendelParams=[];
end

if nargin==1
    plot_outputs(out)
    animate_outputs(out)
elseif nargin==2
    plot_outputs(out,true,name)
    animate_outputs(out,SchlittenPendelParams,true,name)
else
    plot_outputs(out,true,name,path)
    animate_outputs(out,SchlittenPendelParams,true,name,path)
end

end