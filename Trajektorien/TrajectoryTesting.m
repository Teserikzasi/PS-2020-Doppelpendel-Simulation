%% Trajektorientest
name = 'Fauve_MPC_Traj2_0.6_0.3_result_04';
trj = load([name '.mat']);
parent = uipanel('Position', [0, 0.75, 1, 0.25],'Title', name);
PlotTraj_ij(parent, trj.ubx1, trj.X_prediction, trj.Pendulum_Param, trj.u_prediction, trj.T, trj.x_init, trj.x_end);
simout = simTraj(trj.u_prediction, trj.N, trj.T, trj.x_init);
%plotanimate(simout, 'Traj14_Fauve_ohneCoul_ohneInduktion', 'Trajektorien_Tests');
plotanimate(simout);