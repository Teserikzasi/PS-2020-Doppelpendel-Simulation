% Suche nach zulässigen Trajektorien 
% --> Auswahl der Trajektorien mit selectTrajectories

import casadi.*

%% Wähle Parameter für Trajektorienberechnung
N = 350; % Zeithorizont
T = 0.01; % Schrittweite
x_init = []; 
x_end = []; 
x0_max = []; 
ipopt_max_iter = 10000; %3000;

% Zustandsgleichungen (Kraftmodell)
coulomb = false;
%[ode_TesGeb, x, u] = getODE(coulomb);
[ode_Fauve, x, u] = getODE_Fauve();
ode = [];

% Stellgrößenbeschränkung
u_max = 421; % Dummy

%% Speicherordner
coulStatus = '';
if exist('ode_TesGeb', 'var')
    ode = ode_TesGeb; % ode für MPC übergeben
    odeFrom = 'odeTesGeb';
    if coulomb
        coulStatus = 'Coul_';
    end    
elseif exist('ode_Fauve', 'var')
    ode = ode_Fauve; % ode für MPC übergeben
    odeFrom = 'odeFauve';
else
    fprintf('Bitte wähle in trajectorySearch eine getODE()-Zeile aus.\n')
    return
end
resFolderName = ['Results_' odeFrom '_' coulStatus  'maxIt' num2str(ipopt_max_iter)];
subfolderPath = 'Trajektorien\searchResults';
fullFolderPath = fullfile(subfolderPath, resFolderName);
if ~exist(fullFolderPath, 'dir')
    mkdir(fullFolderPath)
end

%% Trajektoriensuche
% Abweichung zum Ziel-Arbeitspunkt
dev_x0 = [0.5 0.3 0.1 0];
dev_AP_phi1 = [pi -pi  pi -pi -pi pi 0   0];   
dev_AP_phi2 = [pi  pi -pi -pi  0  0 -pi  pi]; 

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
                conficMPC.Q = diag([500, 0.01, 100, 0.1, 100, 0.1]);
                conficMPC.R = 0.0000005; 
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
                switch AP_end
                    case 1
                        if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                            AP_init = 4;
                        elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                            AP_init = 2;
                        else
                            AP_init = 3;
                        end
                    case 2
                        if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                            AP_init = 3;
                        elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                            AP_init = 4;
                        else
                            AP_init = 1;
                        end
                    case 3
                        if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                            AP_init = 2;
                        elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                            AP_init = 1;
                        else
                            AP_init = 4;
                        end                               
                    case 4
                        if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                            AP_init = 1;
                        elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                            AP_init = 2;
                        else
                            AP_init = 3;
                        end
                end
                                      
                % speichern der MPC-Ergebniss im Ordner searchResults                   
                fileName = ['Traj' num2str(AP_init) num2str(AP_end)  ...
                        '_dev' num2str(dev_x0(k_pos)) '_' sprintf('%0.2f',devInitPhi1) '_' ...
                      sprintf('%0.2f',devInitPhi2) '_x0max'  num2str(x0_max) '.mat'];
                filePath = fullfile(pwd, fullFolderPath, fileName);                 
                save(filePath, 'results_traj', 'x_init', 'x_end', 'x0_max', 'T', 'devInitPhi1', 'devInitPhi2'); % ggf. alte Files überschreiben
                    
%                     % plotten
%                     parent = uipanel('Position', [0, 0.75, 1, 0.25],'Title', fileName);
%                     PlotTraj_ij(parent, x0_max, results_traj.x_traj', SchlittenPendelParams, results_traj.u_traj, T, x_init, x_end);
%                     % simulieren und animieren
%                     simout = simTraj(results_traj.u_traj, N, T, x_init);
%                     plotanimate(simout);
            end              
        end
    end
end

%% Auswertung
% speichert mit Fehlerbedingung selektierte Trajektorien in savedTrajectories
selectTrajectories(0.01); 

