function examParameters(poi, poi_val)

global Ruhelagen

%% Modellparameter Versuchsreihe
% Reibung
coulomb_Fc = false;
coulomb_Mc = false;

params_Apprich = SchlittenPendelParams_Apprich09();
%params_Ribeiro = SchlittenPendelParams_Ribeiro20();

params = [];
if exist('params_Apprich', 'var')
    params = params_Apprich;
    paramsStr = '_app09';
elseif exist('params_Ribeiro', 'var')
    params = params_Ribeiro;
    paramsStr = '_rib20';
else
    disp('Bitte wähle eine Modellparameter-Zeile aus.')
    return
end

%% Speicherordner
% Trajektorien
fullFolderPath = fullfile('Trajektorien', ['ParameterExams' paramsStr]);
if ~exist(fullFolderPath, 'dir')
    mkdir(fullFolderPath)
end

% Auswertung
plotsPath = 'Trajektorien_Tests';

%% MPC Parameter
% Vergleichstrajektorie
AP_end = 4;
AP_init = 1;
devInitPhi1 = -pi;
devInitPhi2 = -pi;
dev_x0 = 0;
x_init = Ruhelagen(AP_end).x + [-dev_x0 0 devInitPhi1 0 devInitPhi2 0]';
x_end = Ruhelagen(AP_end).x + [dev_x0 0 0 0 0 0]';

% Solver Optionen
opts = struct;
opts.ipopt.max_iter = 10000;

% Eingangsstruktur für Trajektorienberechnung
N = 500;
T = 0.005;
Q = diag([500, 0.01, 100, 0.1, 100, 0.1]);
R = 0.0000005;  
S = 1.5*1e-8;
simSol = 'RK4'; % 'Euler' oder 'RK4'
x0_max = 0.8;
u_max = 400;

%% Durchführung der Versuchsreihe
for i=1 : length(poi_val)
    if isfield(params, poi)
        params.(poi) = poi_val(i);
    else
        disp('Versuchsparameter ist kein gültiger Schlittenpendelparameter')
        return
    end
    
    % Zustandsgleichungen
    [ode, x, u] = getODE(coulomb_Fc, coulomb_Mc, params);
    
    % MPC Konfiguration
    conficMPC = struct;
    conficMPC.ode = ode;
    conficMPC.x = x;
    conficMPC.u = u;    
    conficMPC.N = N;
    conficMPC.T = T;
    conficMPC.Q = Q;
    conficMPC.R = R; 
    conficMPC.S = S;
    conficMPC.simSol = simSol;
    conficMPC.x_init = x_init;
    conficMPC.x_end = x_end;
    conficMPC.x0_max = x0_max;
    conficMPC.u_max = u_max;
    %conficMPC.condition = 0.2;
    conficMPC.opts = opts;
    conficMPC.x_init = x_init;
    conficMPC.x_end = x_end;

    % suche Trajektorie
    results_traj = calculateTrajectory(conficMPC);

    % speichern der MPC-Ergebnisse                   
    fileName = ['Traj' num2str(AP_init) num2str(AP_end)  ...
            '_dev' num2str(dev_x0) '_' sprintf('%0.2f',devInitPhi1) '_' ...
          sprintf('%0.2f',devInitPhi2) '_x0max'  num2str(x0_max) '_' poi '_' num2str(poi_val(i)) '.mat'];
    filePath = fullfile(fullFolderPath, fileName);
    
    save(filePath, 'results_traj', 'x_init', 'x_end', 'x0_max', 'T', 'N', ...
        'devInitPhi1', 'devInitPhi2'); % ggf. alte Files überschreiben     
    fprintf('%s\n', fileName);
end
end

