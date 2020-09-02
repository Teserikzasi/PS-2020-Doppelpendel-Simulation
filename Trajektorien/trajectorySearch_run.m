% Suche nach zulässigen Trajektorien 

global SchlittenPendelParams

% Parameter für Trajektorienberechnung
N = 350;
T = 0.01; 
x_init = []; 
x_end = []; 
x0_max = []; 

% Stellgrößenbeschränkung
u_max = 421; % Dummy

%% Trajektoriensuche
% Abweichung zum Ziel-Arbeitspunkt
dev_x0 = [0.5 0.3 0.1 0];
dev_AP_phi1 = [pi -pi  pi -pi -pi pi 0   0];   
dev_AP_phi2 = [pi  pi -pi -pi  0  0 -pi  pi]; 

% Trajektoriensuche
for k_ubx0=1 : 5   % Variation der Positionsbeschränkung
    x0_max = 0.4+0.2*k_ubx0;   
    
    for k_pos=1 : length(dev_x0)  % Variation der Position
        for k_AP=1 : 4    % Variation des Ziel-Arbeitspunkts
            for k_dev_phi=1 : length(dev_AP_phi1)   % Variation der Pendelausgangslage
                devInitPhi1 = dev_AP_phi1(k_dev_phi);
                devInitPhi2 = dev_AP_phi2(k_dev_phi);
                x_init = Ruhelagen(k_AP).x + [-dev_x0(k_pos) 0 devInitPhi1 0 devInitPhi2 0]';
                x_end = Ruhelagen(k_AP).x + [dev_x0(k_pos) 0 0 0 0 0]';
                
                % Solver Optionen
                opts = struct;
                opts.ipopt.max_iter = 2000; %10000;

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
                
                % suche Trajektorie
                results_traj = calculateTrajectory(conficMPC);
                fprintf('ubx0=%i; pos=%i; AP=%i; dev_phi=%i\n' , k_ubx0, k_pos, k_AP, k_dev_phi)
                
                % wenn Trajektorie zulässig, dann speichern
                if results_traj.condition == 1                 
                    % ermittle AP der Ausgangslage
                    switch k_AP
                        case 1
                            if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                                ap_init = 4;
                            elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                                ap_init = 2;
                            else
                                ap_init = 3;
                            end
                        case 2
                            if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                                ap_init = 3;
                            elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                                ap_init = 4;
                            else
                                ap_init = 1;
                            end
                        case 3
                            if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                                ap_init = 2;
                            elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                                ap_init = 1;
                            else
                                ap_init = 4;
                            end                               
                        case 4
                            if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                                ap_init = 1;
                            elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                                ap_init = 2;
                            else
                                ap_init = 3;
                            end
                    end
                                      
                    % speichern
                    fileName = ['Traj' num2str(ap_init) num2str(k_AP)  ...
                            '_dev' num2str(dev_x0(k_pos)) '_' num2str(devInitPhi1) '_' ...
                            num2str(devInitPhi2) '_x0max'  num2str(x0_max) '.mat'];
                    filePath = [pwd '\Trajektorien\savedTrajectories\'];
                    fileName = avoidOverwrite(fileName, 2, 1);
                    save([filePath '\' fileName], 'results_traj', 'x_init', 'x_end', 'x0_max', 'T', 'devInitPhi1', 'devInitPhi2');
                    
                    % plotten
                    parent = uipanel('Position', [0, 0.75, 1, 0.25],'Title', fileName);
                    PlotTraj_ij(parent, x0_max, results_traj.x_traj', SchlittenPendelParams, results_traj.u_traj, T, x_init, x_end);
                    % simulieren und animieren
                    simout = simTraj(results_traj.u_traj, N, T, x_init);
                    plotanimate(simout);
                end              
            end
        end
    end
end


