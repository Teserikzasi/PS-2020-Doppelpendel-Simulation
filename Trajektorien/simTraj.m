function simout = simTraj(u_traj, x_traj, N, T, x_init, mdl, sol, fixedStep)
% Simuliere Trajektorie am Gesamtmodell

t = 0: T :N*T;
u_sim = timeseries([u_traj; 0], t, 'Name', 'F_steuer'); 
x_sim = timeseries(x_traj, t, 'Name', 'x_traj'); 


global simparams
simparams.Traj.F = u_sim; % Trajektorie
simparams.Traj.x = x_sim;
simparams.gesamtmodell.schlittenpendel.x0 = x_init; % Anfangswerte

tsim = N*T;

if ~exist('mdl', 'var')
    mdl = 'Trajektorien_test';
end
if exist('sol', 'var')
    set_param(mdl, 'Solver', sol);
end
if exist('fixedStep', 'var')
    set_param(mdl, 'Solver', sol, 'StopTime', num2str(tsim), 'FixedStep', num2str(fixedStep));
end
set_param(mdl,'StopTime', num2str(tsim));    

simout = sim(mdl);

end