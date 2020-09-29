
% Trajektorie visualisieren
%plotanimate_traj(trj, trajName, 'Trajektorien_Tests')

mdl = 'Trajektorienfolgeregelung_test';
%% Simulation 1
sol = 'ode1'; fixedStep = trj.T;
out1 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, sol, fixedStep);
plotanimate(out1, [trajName '_' sol '_TFReg'], 'Trajektorien_Tests')
%plotanimate(out1)

%% Simulation 2 
sol = 'ode15s';
out2 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, sol);
%plotanimate(out2, [trajName '_' sol '_TFReg'], 'Trajektorien_Tests')
plotanimate(out2)

