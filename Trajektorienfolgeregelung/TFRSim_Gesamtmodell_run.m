% Trajektoriensimulation MIT Regler
% Vorraussetzung: InitTrajreg

% Trajektorie visualisieren
%plotanimate_traj(trj, trajName, 'Trajektorien_Tests')

mdl = 'TRF_Gesamtmodell_test';
clear opt_params
i=1;
opt_params(i,:) = [mdl, "StopTime", num2str(trj.N*trj.T)]; i=i+1;
opt_params(i,:) = [mdl+"/TFROnOff", "sw", "1"]; i=i+1;% Regelung ON
opt_params(i,:) = [mdl+"/outofcontrolONOFF", "sw", "1"]; i=i+1; % Außer-Kontroll-Stopp ON
opt_params(i,:) = [mdl+"/StörOnOff", "sw", "0"]; i=i+1; % Störung OFF
%% Simulation 1
sol = "ode1";
opt_params(i,:) = [mdl, "Solver", sol]; i=i+1;
opt_params(i,:) = [mdl, "FixedStep", num2str(trj.T)]; i=i+1;
out1 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, opt_params);
Auswertung(out1);
plotanimate(out1, [trajName '_' convertStringsToChars(sol) '_TFR_GM'], 'Trajektorien_Tests')
plot_velocities(out1, true, [trajName '_' convertStringsToChars(sol) '_TFR_GM_vel'], 'Trajektorien_Tests')

%% Simulation 2
sol = "ode4";
opt_params(i,:) = [mdl, "Solver", sol]; i=i+1;
opt_params(i,:) = [mdl, "FixedStep", num2str(trj.T)]; i=i+1;
out2 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, opt_params);
Auswertung(out2);
plotanimate(out2, [trajName '_' convertStringsToChars(sol) '_TFR_GM'], 'Trajektorien_Tests')
%plot_velocities(out2, true, [trajName '_' convertStringsToChars(sol) '_TFR_GM_vel'], 'Trajektorien_Tests')

%% Simulation 3 
sol = "ode45";
opt_params(i,:) = [mdl, "Solver", sol];
out3 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, opt_params);
Auswertung(out3);
plotanimate(out3, [trajName '_' convertStringsToChars(sol) '_TFR_GM'], 'Trajektorien_Tests')
plot_velocities(out3, true, [trajName '_' convertStringsToChars(sol) '_TFR_GM_vel'], 'Trajektorien_Tests')


