% Trajektoriensimulation mit Regler
% Vorraussetzung: InitTrajreg

% Trajektorie visualisieren
%plotanimate_traj(trj, trajName, 'Trajektorien_Tests')

mdl = 'Trajektorienfolgeregelung_test';
%% Simulation 1
sol = 'ode1'; fixedStep = trj.T;
out1 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, sol, fixedStep);
Auswertung(out1)
plotanimate(out1, [trajName '_' sol '_TFReg'], 'Trajektorien_Tests')

%% Simulation 2
sol = 'ode4'; fixedStep = trj.T;
out2 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, sol, fixedStep);
Auswertung(out2)
plotanimate(out2, [trajName '_' sol '_TFReg'], 'Trajektorien_Tests')

%% Simulation 3 
sol = 'ode45';
out3 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, sol);
Auswertung(out3)
plotanimate(out3, [trajName '_' sol '_TFReg'], 'Trajektorien_Tests')


