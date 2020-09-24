% Initialisierung der Trajektorienfolgeregelung
global TrajRegData
global sysF;
searchPath = 'Trajektorien\searchResults\Results_odeTesGeb_app09_maxIt10000\Euler_MPC';
fileName = 'Traj23_dev0_3.14_3.14_x0max0.8';
trj = load(fullfile(searchPath, fileName));
vT = 0 : trj.T : (trj.T)*(trj.N);
stTraj.T.data = vT;
stTraj.X.data = (trj.results_traj.x_traj)';
stTraj.U.data = trj.results_traj.u_traj;
[regData, beoData] = Traj_QR();
TrajRegData = calcTrajRegData(sysF, stTraj, regData, beoData);