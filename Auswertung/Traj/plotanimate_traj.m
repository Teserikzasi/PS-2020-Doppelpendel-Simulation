function plotanimate_traj(trj, filename, plotsPath, fps, speedFactor)
% Erstellt Plot und Animation eine Trajektorie
if ~exist('speedFactor', 'var')
    speedFactor = 1;
end
if ~exist('fps', 'var')
    fps = 100;
end

% Trajektoriendaten in Simulinkoutput-Format konvertieren
vT = 0 : trj.T : (trj.T)*(trj.N);
y_traj = trj.results_traj.x_traj([1 3 5],:);
x_traj = trj.results_traj.x_traj;
u_traj = trj.results_traj.u_traj;
mY = timeseries(y_traj, vT, 'Name', 'mY'); 
mX = timeseries(x_traj, vT, 'Name', 'mX');
vF = timeseries([u_traj; 0], vT, 'Name', 'vF');
outTraj = tscollection({mY; mX; vF});

if nargin==1
    saving = false;
else 
    saving = true;
end

% Animation
if saving
    fprintf('%s\n', filename)
    animate_outputs(outTraj, fps, speedFactor, true, filename, plotsPath);
else 
    animate_outputs(outTraj);
end

% Plot
hFigure = plot_traj(trj);  
if saving
    exportgraphics(hFigure, ['Plots\' plotsPath '\' filename '.png'], 'Resolution', 300);
end

end

