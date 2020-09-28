function hFigure = plot_traj(trj)
% Plottet Trajektorie

% Trajektoriendaten in Simulinkoutput-Format konvertieren
vT = 0 : trj.T : (trj.T)*(trj.N);
x_traj = trj.results_traj.x_traj;
u_traj = trj.results_traj.u_traj;

hFigure = figure();
for i=1:6
    subplot(7, 1, i)
    plot(vT, x_traj(i, :))
    title(['x', num2str(i)])
end
subplot(7, 1, 7)
plot(vT, [u_traj; 0])
title('U');
    
end

