function searchTrajectories(N, T, simSol, paramsSource, u_max, mode, coulMc, coulFc, selectSuccess, nameExtension, fullFolderPath)
% Suche nach Trajektorien 

import casadi.*
global Ruhelagen
%% Wähle Parameter für Trajektorienberechnung
% N = 500; % Zeithorizont
% T = 0.005; % Schrittweite
ipopt_max_iter = 20000; %3000;
Q = diag([500, 0.01, 100, 0.1, 100, 0.1]);
R = 0.0000005; 
S = 1.5*1e-8;

% --------Modellparameter--------------------------------------------------
if isstruct(paramsSource)
    params = paramsSource;
elseif ischar(paramsSource)   
    if strcmp(paramsSource, 'app09')
    params = SchlittenPendelParams_Apprich09();
    elseif strcmp(paramsSource, 'rib20')
        params = SchlittenPendelParams_Ribeiro20();
    else
        disp('Keine zulässige Parameterquelle (paramsSource) gewählt.')
        return
    end
    paramsStr = ['_' paramsSource];
else
    disp('paramsSource hat kein gültiges Format (gültig sind char oder struct).')
end

% --------Zustandsgleichungen (Kraftmodell)--------------------------------
[ode_TesGeb, x, u] = getODE(coulFc, coulMc, params);
%[ode_Fauve, x, u] = getODE_Fauve();

ode = [];
coulStatus = '';
if exist('ode_TesGeb', 'var')
    ode = ode_TesGeb; % ode für MPC übergeben
    odeStr = '_odeTesGeb';
    if coulFc && coulMc
        coulStatus = '_Fc_Mc';
    elseif coulFc
        coulStatus = '_Fc';
    elseif coulMc
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
% simSol = 'RK4'; % 'Euler' oder 'RK4'

% --------Stellgrößenbeschränkung------------------------------------------
% u_max = 450; % [N]

%% Speicherordner
if ~exist('fullFolderPath', 'var')
    subfolderPath1 = 'Trajektorien\searchResults';
    subfolderPath2 = ['Results' odeStr paramsStr coulStatus '_T' num2str(T) 'N' num2str(N)];
    resFolderName = [simSol '_MPC'];
    fullFolderPath = fullfile(subfolderPath1, subfolderPath2, resFolderName);
end
if ~exist(fullFolderPath, 'dir')
    mkdir(fullFolderPath)
end

% ggf. Kennzeichnung am Ende des Dateinamen
if ~exist('nameExtension', 'var')
    nameExt = '';
elseif strcmp(nameExtension(1), '_')
    nameExt=nameExtension;     
else
    nameExt = ['_' nameExtension];
end

%% Trajektoriensuche
% Abweichung zum Ziel-Arbeitspunkt
[dev_x0, dev_AP_phi1, dev_AP_phi2] = getInitDev();
x_init = []; 
x_end = []; 
x0_max = []; 

% Suchprogramm
switch mode
    case 1 % Suche Traj14_dev0_-3.14_-3.14_x0max0.8
        k_ubx0_start = 2; k_ubx0_end = 2;  
        k_pos_start = 4; k_pos_end = 4;
        APend_start = 4; APend_end = 4;
        k_dev_phi_start = 4; k_dev_phi_end = 4;
    case 2 % Suche verschiedene Traj14-Variationen
        k_ubx0_start = 1; k_ubx0_end = 5;  
        k_pos_start = 1; k_pos_end = length(dev_x0);
        APend_start = 4; APend_end = 4;
        k_dev_phi_start = 1; k_dev_phi_end = 4;
    case 3 % Suche Variationen für alle Trajektorien
        k_ubx0_start = 1; k_ubx0_end = 5;  
        k_pos_start = 1; k_pos_end = length(dev_x0);
        APend_start = 1; APend_end = 4;
        k_dev_phi_start = 1; k_dev_phi_end = length(dev_AP_phi1);
end
       

% Trajektoriensuche
for k_ubx0 = k_ubx0_start : k_ubx0_end   % Variation der Positionsbeschränkung
    x0_max = 0.4+0.2*k_ubx0;       
    for k_pos = k_pos_start : k_pos_end % Variation der Position
        for APend = APend_start : APend_end   % Variation des Ziel-Arbeitspunkts
            for k_dev_phi = k_dev_phi_start : k_dev_phi_end  % Variation der Pendelausgangslage
                devInitPhi1 = dev_AP_phi1(k_dev_phi);
                devInitPhi2 = dev_AP_phi2(k_dev_phi);
                x_init = Ruhelagen(APend).x + [-dev_x0(k_pos) 0 devInitPhi1 0 devInitPhi2 0]';
                x_end = Ruhelagen(APend).x + [dev_x0(k_pos) 0 0 0 0 0]';
                
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
                conficMPC.opts = opts;
                conficMPC.ode = ode;
                conficMPC.x = x;
                conficMPC.u = u;
                
                % suche Trajektorie
                results_traj = calculateTrajectory(conficMPC);
                fprintf('k_ubx0=%i; k_pos=%i; AP_end=%i; k_dev_phi=%i; dev=%0.5f\n' , k_ubx0, k_pos, APend, k_dev_phi, results_traj.dev)
                               
                % ermittle AP der Ausgangslage
                APinit = determineAPinit(APend, devInitPhi1, devInitPhi2);
                                      
                                  
                % Trajektorienbezeichnung anzeigen                             
                fileName = ['Traj' num2str(APinit) num2str(APend)  ...
                    '_dev' num2str(dev_x0(k_pos)) '_' sprintf('%0.2f',devInitPhi1) '_' ...
                  sprintf('%0.2f',devInitPhi2) '_x0max'  num2str(x0_max) ...
                  '_Fmax' num2str(u_max) nameExt '.mat'];
                filePath = fullfile(fullFolderPath, fileName);
                fprintf('%s\n', fileName);
                
                % Speichern der MPC-Ergebnisse
                saving = false;
                if ~exist('selectSuccess', 'var')
                    selectSuccess = false;
                end 
                if selectSuccess % ggf. nur speichern, wenn "Optimal Solution Found"
                    if results_traj.success
                        saving = true;
                    end
                else 
                    saving = true;
                end 
                if saving  
                    save(filePath, 'results_traj', 'x_init', 'x_end', 'x0_max', 'T', 'N', ...
                                'devInitPhi1', 'devInitPhi2'); % mit Überschreiben
                    fprintf('Gespeichert unter %s\n', filePath);    
                end
                
            end              
        end
    end
end

end

