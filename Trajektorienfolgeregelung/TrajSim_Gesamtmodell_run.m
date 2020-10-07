% Trajektoriensimulation OHNE Regler
% Vorraussetzung: InitTrajreg

% Trajektorie visualisieren
%plotanimate_traj(trj, trajName, 'Trajektorien_Tests')

mdl = "TRF_Gesamtmodell_test";
clear opt_params
i=1;
opt_params(i,:) = [mdl, "StopTime", num2str(trj.N*trj.T)]; i=i+1;
opt_params(i,:) = [mdl+"/TFROnOff", "sw", "0"]; i=i+1;% Regelung OFF
opt_params(i,:) = [mdl+"/outofcontrolONOFF", "sw", "0"]; i=i+1; % Außer-Kontroll-Stopp OFF
opt_params(i,:) = [mdl+"/StörOnOff", "sw", "0"]; i=i+1; % Störung OFF
%% Simulation 1
sol = "ode1";
opt_params(i,:) = [mdl, "Solver", sol]; i=i+1;
opt_params(i,:) = [mdl, "FixedStep", num2str(trj.T)]; i=i+1;
out1 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, opt_params);
plotanimate(out1, [trajName '_' convertStringsToChars(sol) '_GM'], 'Trajektorien_Tests')

%% Simulation 2
sol = "ode4";
opt_params(i,:) = [mdl, "Solver", sol]; i=i+1;
opt_params(i,:) = [mdl, "FixedStep", num2str(trj.T)]; i=i+1;
out2 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, opt_params);
plotanimate(out2, [trajName '_' convertStringsToChars(sol) '_GM'], 'Trajektorien_Tests')

%% Simulation 3 
sol = "ode45";
opt_params(i,:) = [mdl, "Solver", sol];
out3 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, opt_params);
plotanimate(out3, [trajName '_' convertStringsToChars(sol) '_GM'], 'Trajektorien_Tests')
