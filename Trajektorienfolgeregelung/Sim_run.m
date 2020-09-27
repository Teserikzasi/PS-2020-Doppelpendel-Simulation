
searchPath = 'Trajektorien\searchResults\Results_odeTesGeb_app09_maxIt10000\Euler_MPC';


fileName = 'Traj14_dev0_-3.14_-3.14_x0max0.8'; % Vergleichstrajektorie
fullPath = fullfile(searchPath, fileName);


% Laden
try
    trj = load([fullPath '.mat']);
catch
    disp('Fehler beim Laden der Trajektorie.')
end

% Trajektorie visualisieren
%plotanimate_traj(trj, fileName, 'Trajektorien_Tests')

%% Simulation 1
mdl = 'Trajektorienfolgeregelung_test';

sol = 'ode1'; fixedStep = trj.T;
out1 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, sol, fixedStep);
plotanimate(out1, [fileName '_' sol '_TFReg'], 'Trajektorien_Tests')

%% Simulation 2 
sol = 'ode45';
out2 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, sol);
plotanimate(out2, [fileName '_' sol '_TFReg'], 'Trajektorien_Tests')
%plotanimate(out2)

