
pth = 1; % WÄHLE Pfad aus
% HINWEIS: Vorher die Systemgleichungen mit entsprechendem Parametersatz
% initialisieren

%--------------------------------------------------------------------------
searchPath{1} = 'Trajektorien\searchResults\Results_odeTesGeb_app09_maxIt10000\Euler_MPC';
searchPath{2} = 'Trajektorien\searchResults\Results_odeTesGeb_rib20_maxIt10000\Euler_MPC';
searchPath{3} = 'Trajektorien\searchResults\Results_odeTesGeb_rib20_Mc_maxIt10000\Euler_MPC';

fileName = 'Traj14_dev0_-3.14_-3.14_x0max0.8'; % direkte Vergleichstrajektorie
for i=1 : length(searchPath)
    fullPath{i} = fullfile(searchPath{i}, fileName);
end

% Laden
try
    trj = load([fullPath{pth} '.mat']);
catch
    disp('Fehler beim Laden der Trajektorie.')
end

% Trajektorie visualisieren
plotanimate_traj(trj, fileName, 'Trajektorien_Tests')

%% Simulation 
mdl = 'Trajektorien_test';

sol = 'ode4'; fixedStep = trj.T;
out1 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, sol, fixedStep);
plotanimate(out1, [fileName '_' sol], 'Trajektorien_Tests')

%%
sol = 'ode45';
out2 = simTraj(trj.results_traj.u_traj, trj.results_traj.x_traj, trj.N, trj.T, trj.x_init, mdl, sol);
plotanimate(out2, [fileName '_' sol], 'Trajektorien_Tests')

