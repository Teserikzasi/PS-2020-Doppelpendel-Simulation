%% Trajektorientest
% name = 'Fauve_MPC_Traj2_0.6_0.3_result_04';
% trj = load([name '.mat']);
% parent = uipanel('Position', [0, 0.75, 1, 0.25],'Title', name);
% PlotTraj_ij(parent, trj.ubx1, trj.X_prediction, trj.Pendulum_Param, trj.u_prediction, trj.T, trj.x_init, trj.x_end);
%simout = simTraj(trj.u_prediction, trj.N, trj.T, trj.x_init);

N=350; % ...wird noch in die Files integriert
filePath = 'Trajektorien\searchResults\Results_odeFauve_maxIt10000\Selection';
fileName = 'Traj41_dev0.1_3.14_3.14_x0max0.8';
fullName = fullfile(filePath, fileName);
trj = load([fullName '.mat']);
parent = uipanel('Position', [0, 0.75, 1, 0.25],'Title', fileName);
PlotTraj_ij(parent, trj.x0_max, trj.results_traj.x_traj', SchlittenPendelParams, trj.results_traj.u_traj, trj.T, trj.x_init, trj.x_end);
simout = simTraj(trj.results_traj.u_traj, N, trj.T, trj.x_init);

%plotanimate(simout, 'Traj14_Fauve_ohneCoul_ohneInduktion', 'Trajektorien_Tests');
plotanimate(simout);



