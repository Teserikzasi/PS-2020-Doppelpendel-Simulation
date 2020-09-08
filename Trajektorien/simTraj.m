function simout = simTraj(u_traj, N, T, x_init)
% Simuliere Trajektorie am Gesamtmodell

t = 0: T :(length(u_traj)-1)*T;
u_sim = timeseries(u_traj, t, 'Name', 'F_steuer'); 

global simparams
simparams.F_traj = u_sim; % Trajektorie
simparams.gesamtmodell.schlittenpendel.x0 = x_init; % Anfangswerte

tsim = N*T;
simout = sim('Trajektorien_test', tsim);

end