function simout = simTraj(u_traj, x_traj, N, T, x_init, mdl, opt_params)
% Simuliere Trajektorie am Gesamtmodell

% Trajektorie als Timeseries formulieren
t = 0: T :N*T;
u_sim = timeseries([u_traj; 0], t, 'Name', 'F_steuer'); 
x_sim = timeseries(x_traj, t, 'Name', 'x_traj'); 

% Simulation initialisieren
global simparams
simparams.Traj.F = u_sim; % Trajektorie
simparams.Traj.x = x_sim;
simparams.gesamtmodell.schlittenpendel.x0 = x_init; % Anfangswerte

open_system(mdl);

if ~exist('mdl', 'var')
    mdl = 'Trajektorien_test';
end

if exist('opt_params','var')
    for i=1:length(opt_params(:,1))
        set_param(opt_params(i,1), opt_params(i,2), opt_params(i,3));
    end
end

% Simulation
simout = sim(mdl);

end