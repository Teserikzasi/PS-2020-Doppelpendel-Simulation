% HINWEIS: Das Skript ist für die abschnittsweise Ausführung konzipiert!
% Editor--> "Run Section"

%% Manuelle Trajektorien-Selektion
searchPath = 'Trajektorien\searchResults\Results_odeFauve_maxIt10000\Euler_MPC';
%selectTrajectories_best_End(false, searchPath); % beste 12 Trajektorien, falls gültig
selectTrajectories_best_InitEnd(true, searchPath);
%selectTrajectories_cond(0.1, false, searchPath); % selektiert nach Fehlerbedingung

%% Manuell "Ergbenisse.txt"-File schreiben
searchPath = 'Trajektorien\searchResults\Results_odeTesGeb_rib20_Mc_maxIt10000\Euler_MPC';
dfile = fullfile(searchPath, 'Ergebnisse.txt');
if exist(dfile, 'file'); delete(dfile); end
diary(dfile)
diary on
selectTrajectories_best_InitEnd(false, searchPath); % beste 12 Trajektorien, falls gültig
selectTrajectories_best_End(false, searchPath);
selectTrajectories_cond(0.01, false, searchPath); % selektiert nach Fehlerbedingung
selectTrajectories_cond(0.1, false, searchPath);
selectTrajectories_cond(1, false, searchPath);
diary off

%% Gib devs auf Konsole aus
searchPath = 'Trajektorien\searchResults\Results_odeTesGeb_rib20_Mc_maxIt10000\Euler_MPC';
printDev(searchPath)

%% Lade und simuliere eigene Trajektorien
filePath = 'Trajektorien\searchResults\Results_odeTesGeb_app09_maxIt10000\RK4_MPC';
%filePath = 'Trajektorien\searchResults\Results_odeTesGeb_Coul_maxIt10000';
%filePath = 'Trajektorien\savedTrajectories';
% fileName = 'Traj14_dev0_3.14_3.14_x0max0.8'; % Vergleichstrajektorie
fileName = 'Traj14_dev0.1_-3.14_-3.14_x0max1.2';

fullName = fullfile(filePath, fileName);
try
    trj = load([fullName '.mat']);
catch
    disp('Fehler beim Laden der Trajektorie.')
end
simout = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init);
disp('Simulation abgeschlossen.')
parent = uipanel('Position', [0, 0.75, 1, 0.25],'Title', fileName);
PlotTraj_ij(parent, trj.x0_max, trj.results_traj.x_traj', SchlittenPendelParams, trj.results_traj.u_traj, trj.T, trj.x_init, trj.x_end);

%% Visualisiere Simulationsergebnisse
plot_velocities(simout)
plotanimate(simout);
%% Speichern
plot_velocities(simout, true, [fileName '_velocities'], 'Trajektorien_Tests')
plotanimate(simout, fileName, 'Trajektorien_Tests')


%% Visualisiere Trajektorie
parent = uipanel('Position', [0, 0.75, 1, 0.25],'Title', fileName);
PlotTraj_ij(parent, trj.x0_max, trj.results_traj.x_traj', SchlittenPendelParams, trj.results_traj.u_traj, trj.T, trj.x_init, trj.x_end);
vT = 0 : trj.T : (trj.T)*(trj.N);
y_traj = trj.results_traj.x_traj([1 3 5],:);
mY = timeseries(y_traj, vT, 'Name', 'mY'); 
outTraj = tscollection({mY});
animate_outputs(outTraj, 1);

%% Visualisiere Trajektorie mit Erics Tools
vT = 0 : trj.T : (trj.T)*(trj.N);
stTraj.T.data = vT';
stTraj.X.data = (trj.results_traj.x_traj)';
stTraj.U.data = trj.results_traj.u_traj;
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
trj = load([fileName '.mat']);
parent = uipanel('Position', [0, 0.75, 1, 0.25],'Title', fileName);
PlotTraj_ij(parent, trj.ubx1, trj.X_prediction, trj.Pendulum_Param, trj.u_prediction, trj.T, trj.x_init, trj.x_end);
simout = simTraj(trj.u_prediction, trj.X_prediction', trj.N, trj.T, trj.x_init);
% plot_velocities(simout, true, [fileName '_velocities'], 'Trajektorien_Tests')
% plotanimate(simout, fileName, 'Trajektorien_Tests')
plot_velocities(simout)
plotanimate(simout);

