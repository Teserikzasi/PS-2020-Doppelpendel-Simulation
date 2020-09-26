% Initialisierung der Trajektorienfolgeregelung
global TrajRegData
global sysF;
global simparams
searchPath = 'Trajektorien\searchResults\Results_odeTesGeb_app09_maxIt10000\Euler_MPC';
fileName = 'Traj14_dev0_-3.14_-3.14_x0max0.8.mat';
trj = load(fullfile(searchPath, fileName));
vT = 0 : trj.T : (trj.T)*(trj.N);
stTraj.T.data = vT';
stTraj.X.data = (trj.results_traj.x_traj)';
stTraj.U.data = [trj.results_traj.u_traj; 0];
stTraj.Y.data = stTraj.X.data(:,[1 3 5]);
[regData, beoData] = Traj_QR();
TrajRegData = calcTrajRegData(sysF, stTraj, regData, beoData);
TrajRegData.T.data = stTraj.T.data;



simparams.TrajRegDataF = TrajRegData;
