% Suche nach zulässigen Trajektorien 
% --> Auswahl der Trajektorien mit selectTrajectories

import casadi.*

%% Wähle Parameter für Trajektorienberechnung
N = 350; % Zeithorizont
T = 0.01; % Schrittweite
ipopt_max_iter = 10000; %3000;
Q = diag([500, 0.01, 100, 0.1, 100, 0.1]);
R = 0.0000005; 
S = 1.5*1e-8;

% --------Modellparameter--------------------------------------------------
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

% --------Zustandsgleichungen (Kraftmodell)--------------------------------
coulomb_Fc = false;
coulomb_Mc = false;
[ode_TesGeb, x, u] = getODE(coulomb_Fc, coulomb_Mc, params);
%[ode_Fauve, x, u] = getODE_Fauve();

ode = [];
coulStatus = '';
if exist('ode_TesGeb', 'var')
    ode = ode_TesGeb; % ode für MPC übergeben
    odeStr = '_odeTesGeb';
    if coulomb_Fc && coulomb_Mc
        coulStatus = '_Fc_Mc';
    elseif coulomb_Fc
        coulStatus = '_Fc';
    elseif coulomb_Mc
        coulStatus = '_Mc';
    end    
elseif exist('ode_Fauve', 'var')
    ode = ode_Fauve; % ode für MPC übergeben
    odeStr = '_odeFauve';
else
    fprintf('Bitte wähle eine getODE()-Zeile aus.\n')
    return
end

% --------Integrationsverfahren für Kontinuitätsbedingung------------------
simSol = 'RK4'; % 'Euler' oder 'RK4'

% --------Stellgrößenbeschränkung------------------------------------------
u_max = 400; % Fauve

%% Speicherordner

subfolderPath1 = 'Trajektorien\searchResults';
subfolderPath2 = ['Results' odeStr paramsStr coulStatus '_maxIt' num2str(ipopt_max_iter)];
resFolderName = [simSol '_MPC'];
fullFolderPath = fullfile(subfolderPath1, subfolderPath2, resFolderName);
if ~exist(fullFolderPath, 'dir')
    mkdir(fullFolderPath)
end

%% Trajektoriensuche
% Abweichung zum Ziel-Arbeitspunkt
[dev_x0, dev_AP_phi1, dev_AP_phi2] = getInitDev();
x_init = []; 
x_end = []; 
x0_max = []; 

% Trajektoriensuche
for k_ubx0=1 : 5   % Variation der Positionsbeschränkung
    x0_max = 0.4+0.2*k_ubx0;   
    
    for k_pos=1 : length(dev_x0)  % Variation der Position
        for AP_end=1 : 4    % Variation des Ziel-Arbeitspunkts
            for k_dev_phi=1 : length(dev_AP_phi1)   % Variation der Pendelausgangslage
                devInitPhi1 = dev_AP_phi1(k_dev_phi);
                devInitPhi2 = dev_AP_phi2(k_dev_phi);
                x_init = Ruhelagen(AP_end).x + [-dev_x0(k_pos) 0 devInitPhi1 0 devInitPhi2 0]';
                x_end = Ruhelagen(AP_end).x + [dev_x0(k_pos) 0 0 0 0 0]';
                
                % Solver Optionen
                opts = struct;
                opts.ipopt.max_iter = ipopt_max_iter;

                % Eingangsstruktur für Trajektorienberechnung
                conficMPC = struct;
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
                conficMPC.ode = ode;
                conficMPC.x = x;
                conficMPC.u = u;
                
                % suche Trajektorie
                results_traj = calculateTrajectory(conficMPC);
                fprintf('k_ubx0=%i; k_pos=%i; AP_end=%i; k_dev_phi=%i; dev=%0.5f\n' , k_ubx0, k_pos, AP_end, k_dev_phi, results_traj.dev)
                               
                % ermittle AP der Ausgangslage
                AP_init = determineAPinit(AP_end, devInitPhi1, devInitPhi2);
                                      
                % speichern der MPC-Ergebnisse im Ordner searchResults                   
                fileName = ['Traj' num2str(AP_init) num2str(AP_end)  ...
                        '_dev' num2str(dev_x0(k_pos)) '_' sprintf('%0.2f',devInitPhi1) '_' ...
                      sprintf('%0.2f',devInitPhi2) '_x0max'  num2str(x0_max) '.mat'];
                filePath = fullfile(fullFolderPath, fileName);                 
                save(filePath, 'results_traj', 'x_init', 'x_end', 'x0_max', 'T', 'N', ...
                    'devInitPhi1', 'devInitPhi2'); % ggf. alte Files überschreiben     
                fprintf('%s\n', fileName);
            end              
        end
    end
end

%% Auswertung
dfile = fullfile(fullFolderPath, 'Ergebnisse.txt');
searchPath = fullFolderPath;
if exist(dfile, 'file'); delete(dfile); end
diary(dfile)
diary on
selectTrajectories_best_InitEnd(false, searchPath); % beste 12 Trajektorien, falls gültig
selectTrajectories_best_End(false, searchPath);
selectTrajectories_cond(0.01, false, searchPath); % selektiert nach Fehlerbedingung
selectTrajectories_cond(0.1, false, searchPath);
selectTrajectories_cond(1, false, searchPath);
diary off
