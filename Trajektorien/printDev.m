function printDev(searchPath)
% Gibt Tabelle mit Trajektorien und Endwertfehlern in der Konsole aus
global Ruhelagen
% Ordnerstruktur
if ~exist('searchPath', 'var')
    % Wähle Ordner mit Ergebnissen der Trajektorienberechnung
    subfolderPath1 = 'Trajektorien\searchResults';
    subfolderPath2 = 'Results_odeTesGeb_app09_maxIt10000';
    resFolderName = 'Euler_MPC\Selection_Best';
    searchPath = fullfile(subfolderPath1, subfolderPath2, resFolderName);
end


% Rekonstruktion des Dateinamens (definiert in trajectorySearch)
[dev_x0, dev_AP_phi1, dev_AP_phi2] = getInitDev();
res.maxDev = 0;
res.maxDevInit = 0;
res.name = '';
fprintf('\n%-40s %-17s %s\n', 'Trajektorie', 'Anfangswertfehler', 'Endwertfehler');
for k_ubx0=1 : 5   % Variation der Positionsbeschränkung
    x0_max = 0.4+0.2*k_ubx0;      
    for k_pos=1 : length(dev_x0)  % Variation der Position
        for AP_end=1 : 4    % Variation des Ziel-Arbeitspunkts
            for k_dev_phi=1 : length(dev_AP_phi1)   % Variation der Pendelausgangslage
                devInitPhi1 = dev_AP_phi1(k_dev_phi);
                devInitPhi2 = dev_AP_phi2(k_dev_phi);
                x_init = Ruhelagen(AP_end).x + [-dev_x0(k_pos) 0 devInitPhi1 0 devInitPhi2 0]';
                
                % ermittle AP der Ausgangslage               
                AP_init = determineAPinit(AP_end, devInitPhi1, devInitPhi2);              
                
                fileName = ['Traj' num2str(AP_init) num2str(AP_end)  ...
                        '_dev' num2str(dev_x0(k_pos)) '_' sprintf('%0.2f',devInitPhi1) '_' ...
                      sprintf('%0.2f',devInitPhi2) '_x0max'  num2str(x0_max) '.mat'];
               
               try
                   data = load(fullfile(searchPath, fileName));
                   dev_end = data.results_traj.dev;
                   x_traj = data.results_traj.x_traj;
                   dev_init = norm(x_traj(:,1)-x_init, 2);   
                   if dev_end > res.maxDev
                       res.maxDev = dev_end;
                       res.name = fileName;
                   end
                   if dev_init > res.maxDevInit
                       res.maxDevInit = dev_init;
                       res.name = fileName;
                   end
                       
                   
                   % Ausgabe                   
                   fprintf('%-40s %-17f %f\n', fileName, dev_init, dev_end);                   
               catch
                    
               end                                                 
            end
        end
    end
end
fprintf('Maximaler Endwertfehler\n');
fprintf('%-57s  %f\n', res.name, res.maxDev);
fprintf('Maximaler Anfangswertfehler\n');
fprintf('%-40s %f\n', res.name, res.maxDevInit);


end

