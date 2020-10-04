% Run Section! 

%% Initialisiere Suchpfad
%searchPath = 'Trajektorien\searchResults\Results_odeTesGeb_app09_T0.01N350\Euler_MPC';
searchPath = 'Trajektorien\ParameterExams_app09';
%% Manuelle Trajektorien-Selektion
%selectTrajectories_best_End(false, searchPath); % beste 12 Trajektorien, falls gültig
selectTrajectories_best_InitEnd(true, searchPath);
%selectTrajectories_cond(0.1, false, searchPath); % selektiert nach Fehlerbedingung

%% Manuell "Ergbenisse.txt"-File schreiben
dfile = fullfile(searchPath, 'Ergebnisse.txt');
if exist(dfile, 'file'); delete(dfile); end
diary(dfile)
diary on
selectTrajectories_best_InitEnd(false, searchPath); % beste 12 Trajektorien
selectTrajectories_best_End(false, searchPath);
selectTrajectories_cond(0.01, false, searchPath); % Selektion nach Endwertfehlerbedingung + Gültigkeitsprüfung
selectTrajectories_cond(0.1, false, searchPath);
selectTrajectories_cond(1, false, searchPath);
printDev(searchPath)
diary off

%% Gib devs auf Konsole aus
printDev(searchPath)

%% Lade eine Trajektorien
fileName = 'Traj14_dev0_-3.14_-3.14_x0max0.8_m1_0.3'; % Vergleichstrajektorie
%fileName = 'Traj14_dev0.1_-3.14_-3.14_x0max1.2';
%fileName = 'Traj14_dev0.1_3.14_3.14_x0max0.6';
fullName = fullfile(searchPath, fileName);
try
    trjTest = load([fullName '.mat']);
    disp('Trajektorie geladen.')
catch
    disp('Fehler beim Laden der Trajektorie.')
    return
end

%% Simulation
sol = 'ode1'; fixedStep = trjTest.T;
mdl = 'Trajektorien_test';
simout = simTraj(trjTest.results_traj.u_traj, trjTest.results_traj.x_traj, trjTest.N, trjTest.T, trjTest.x_init, mdl, sol, fixedStep);
disp('Simulation abgeschlossen.')

%% Visualisiere Simulationsergebnisse
%plot_velocities(simout)
%plotanimate(simout);
animate_outputs(simout, 100)

%% Visualisiere Simulationsergebnisse mit Common Tool
outData.T.data = simout.mX.time;
outData.X.data = squeeze(simout.mX.data)';
outData.Y.data = squeeze(simout.mY.data)';
animateDPendulum(outData, SchlittenPendelParams, 1);

%% Speichern
plot_velocities(simout, true, [fileName '_velocities'], 'Trajektorien_Tests')
plotanimate(simout, fileName, 'Trajektorien_Tests')


%% Visualisiere Trajektorie
parent = uipanel('Position', [0, 0.75, 1, 0.25],'Title', fileName);
PlotTraj_ij(parent, trjTest.x0_max, trjTest.results_traj.x_traj', SchlittenPendelParams, trjTest.results_traj.u_traj, trjTest.T, trjTest.x_init, trjTest.x_end);
plotanimate_traj(trjTest)


%% Visualisiere Trajektorie mit Common Tools
vT = 0 : trjTest.T : (trjTest.T)*(trjTest.N);
stTraj.T.data = vT';
stTraj.X.data = (trjTest.results_traj.x_traj)';
stTraj.U.data = [trjTest.results_traj.u_traj; 0];
stTraj.Y.data = stTraj.X.data(:,[1 3 5]);
% Hinweise zur Animation: 
% - der dTimeFactor hat aufgrund der Interpolation starken Einfluss auf die Auflösung des Trajektorienpfads
% - ohne explizite dTimeFactor-Angabe wird mit 1,429-facher Geschwindigkeit wiedergegeben
% - fps=10 fest vorgegeben
dTimeFactor = 1;
animateDPendulum(stTraj, SchlittenPendelParams);
plotTraj(stTraj, {'X' 'U'});



%% Fauve Test-Trajektorie
fileName = 'Fauve_MPC_Traj2_0.6_0.3_result_04';
trjTest = load([fileName '.mat']);
parent = uipanel('Position', [0, 0.75, 1, 0.25],'Title', fileName);
PlotTraj_ij(parent, trjTest.ubx1, trjTest.X_prediction, trjTest.Pendulum_Param, trjTest.u_prediction, trjTest.T, trjTest.x_init, trjTest.x_end);
simout = simTraj(trjTest.u_prediction, trjTest.X_prediction', trjTest.N, trjTest.T, trjTest.x_init);
% plot_velocities(simout, true, [fileName '_velocities'], 'Trajektorien_Tests')
% plotanimate(simout, fileName, 'Trajektorien_Tests')
plot_velocities(simout)
plotanimate(simout);

