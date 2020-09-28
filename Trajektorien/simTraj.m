function simout = simTraj(u_traj, x_traj, N, T, x_init)
% Simuliere Trajektorie am Gesamtmodell

t = 0: T :N*T;
u_sim = timeseries([u_traj; 0], t, 'Name', 'F_steuer'); 
x_sim = timeseries(x_traj, t, 'Name', 'x_traj'); 


global simparams
simparams.Traj.F = u_sim; % Trajektorie
simparams.Traj.x = x_sim;
simparams.gesamtmodell.schlittenpendel.x0 = x_init; % Anfangswerte

tsim = N*T;
simout = sim('Trajektorien_test', tsim);

end