
%% Trajektorie visualisieren
plotanimate_traj(trj, trajName, 'Trajektorien_Tests')

%% Simulation 
mdl = 'Trajektorien_test';

sol = 'ode4'; fixedStep = trj.T;
out1 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, sol, fixedStep);
plotanimate(out1, [trajName '_' sol], 'Trajektorien_Tests')

%%
sol = 'ode45';
out2 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, sol);
plotanimate(out2, [trajName '_' sol], 'Trajektorien_Tests')

