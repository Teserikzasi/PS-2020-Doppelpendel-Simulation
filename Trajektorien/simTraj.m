function simout = simTraj(u_traj, N, T, x_init)
% Simuliere Trajektorie am Gesamtmodell

global simparams
global SchlittenPendelParams

t = 0: T :(length(u_traj)-1)*T;
u_sim = timeseries(u_traj, t, 'Name', 'F_steuer'); 

simparams.F_traj = u_sim; % Trajektorie
SchlittenPendelParams.x0 = x_init; % Anfangswerte

simparams.gesamtmodell.schlittenpendel = SchlittenPendelParams;
tsim = N*T;

%simout = sim('Trajektorien_test', tsim);
simout = sim('Trajektorien_test', tsim);

end

