function plotanimate(out, name, path, fps, speedFactor)
% plot und animate, optional mit speichern
% path relativ zu Plots

if ~exist('speedFactor', 'var')
    speedFactor = 1;
end
if ~exist('fps', 'var')
    fps = 100;
end

if nargin==1
    plot_outputs(out)
    animate_outputs(out)
elseif nargin==2
    plot_outputs(out,true,name)
    animate_outputs(out,fps,speedFactor,true,name)
else
    plot_outputs(out,true,name,path)
    animate_outputs(out,fps,speedFactor,true,name,path)
end

end