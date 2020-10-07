% Initialisierung der Trajektorienfolgeregelung
global TrajRegData
global Zustandsermittlung 
global sysF
global simparams
global trj
global trajName

%% Parameter
% SchlittenPendelParams = SchlittenPendelParams_Apprich09();
SchlittenPendelParams = SchlittenPendelParams_Ribeiro20();
SchlittenPendelParams.Fc0 = 0;
SchlittenPendelParams.Mc10 = 0;
SchlittenPendelParams.Mc20 = 0;
InitSystem(SchlittenPendelParams)

MotorParams = MotorParams_Franke97();% falls K_UI in MotorParams_Franke97 geändert 
simparams.gesamtmodell.motor = MotorParams;
%% Trajektorie
trajPath = 'Trajektorien\searchResults\Results_odeTesGeb_rib20_T0.005N500\Euler_MPC';
%trajPath = 'Trajektorien\ParameterExams_app09';

trajName = 'Traj14_dev0_-3.14_-3.14_x0max0.8_Fmax410';
% trajName = 'Traj14_dev0_-3.14_-3.14_x0max0.8_J1_0.002';
trj = load(fullfile(trajPath, [trajName '.mat']));
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