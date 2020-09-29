% Initialisierung der Trajektorienfolgeregelung
global TrajRegData
global Zustandsermittlung 
global sysF
global simparams
global trj
global trajName

%% Trajektorie
trajPath = 'Trajektorien\searchResults\Results_odeTesGeb_app09_T0.01N350\Euler_MPC';
trajName = 'Traj14_dev0_-3.14_-3.14_x0max0.8.mat';
trj = load(fullfile(trajPath, trajName));
vT = 0 : trj.T : (trj.T)*(trj.N);
stTraj.T.data = vT';
stTraj.X.data = (trj.results_traj.x_traj)';
stTraj.U.data = [trj.results_traj.u_traj; 0];
stTraj.Y.data = stTraj.X.data(:,[1 3 5]);

%% Regler und Beobachter
[regData, beoData] = Traj_QR();
TrajRegData = calcTrajRegData(sysF, stTraj, regData, beoData);
TrajRegData.T.data = stTraj.T.data;
TrajRegData.xb0 = stTraj.X.data(1,:); % Beobachter-Startwert
simparams.TrajRegDataF = TrajRegData;

% Art der Zustandsermittlung
Zustandsermittlung = ["Zustandsmessung","Beobachter","Differenzieren"];
simparams.Zustandsermittlung = 1; % Zustandsmessung: 1 , Beobachter: 2 , Differenzieren: 3