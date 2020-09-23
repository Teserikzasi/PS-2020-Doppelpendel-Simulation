function selectTrajectories_best_InitEnd(savefiles, searchPath, destPath)
% NUR ZU TESTZWECKEN: Die Selektion wird mit "selectTrajectories_best"
% erstellt!
% Wählt für jede der 12 gesuchten Trajektorien die Beste aus.
% Kriterium: Euklidische Norm im Zielzustand und Anfangszustand
global Ruhelagen

% Ordnerstruktur
if ~exist('searchPath', 'var')
    % Wähle Ordner mit Ergebnissen der Trajektorienberechnung
    subfolderPath1 = 'Trajektorien\searchResults';
    subfolderPath2 = 'Results_odeTesGeb_app09_maxIt10000';
    resFolderName = 'Euler_MPC';
    searchPath = fullfile(subfolderPath1, subfolderPath2, resFolderName);
end
if ~exist('destPath', 'var') % Zielpfad
    destPath = fullfile(searchPath, 'Selection_Best_InitEnd');
end
if ~exist(destPath, 'dir')
    if savefiles
        mkdir(destPath);
    end
end

% initialisiere Auswahl
for AP_init=1:4
    for AP_end=1:4
        Selection(AP_init, AP_end) = struct('name', ['Traj' num2str(AP_init) num2str(AP_end)], 'J_dev', inf, 'dev', inf);
    end
end
threshold = 1;

% Rekonstruktion des Dateinamens (definiert in trajectorySearch)
[dev_x0, dev_AP_phi1, dev_AP_phi2] = getInitDev();
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
                
                % file laden
                try
                    data = load(fullfile(searchPath, fileName));
                    loadSuc = true;
                catch
                    fprintf('%s existiert nicht in %s \n', fileName, searchPath);
                    loadSuc = false;
                end  
                % Selektion
                if loadSuc
                    dev = data.results_traj.dev;
                    x_traj = data.results_traj.x_traj;
                    dev_init = norm(x_traj(:,1)-x_init, 2);
                    dev_end = dev; % norm(x_traj(:,end)-Ruhelagen(AP_end).x, 2);
                    if max( abs( x_traj(1, :) ) ) <= 0.7 % Prüft Einhaltung der Positionsbegrenzung
                        if dev_init < threshold    % Prüft Plausibilität des Anfangswerts
                            if dev_end < threshold    % Prüft Plausibilität des Endwerts
                                J = norm([dev_init; dev_end], 2);
                                if  J < Selection(AP_init, AP_end).J_dev % Sucht nach kleinstem Fehlerquadrat aus Endwert- und Anfangswertfehler
                                    Selection(AP_init, AP_end).J_dev = J; %dev_end^2+dev_init^2;
                                    Selection(AP_init, AP_end).name = fileName;
                                    Selection(AP_init, AP_end).dev = dev_end;
                                end
                            end
                        end
                    end
                end                                                  
            end
        end
    end
end

% Speichert Auswahl
if savefiles
    for AP_init=1:4
        for AP_end=1:4
            if AP_init ~= AP_end
                fileName = Selection(AP_init, AP_end).name;               
                try
                   data = load(fullfile(searchPath, fileName));
                   filePath = fullfile(destPath, fileName);
                   save(filePath, '-struct', 'data');
               catch
                   fprintf('%s existiert nicht in %s \n', fileName, searchPath); 
                end
            end
        end
    end
    %fprintf('Auswahl wurde gespeichert unter %s.\n\n', destPath);
else
    %fprintf('Auswahl wurde nicht gespeichert.\n\n');
end

% Zeige Ergebnis an
fprintf('\n\n---Beste Trajektorien bezüglich Anfangs- und Endwertfehler (Schwelle: %f)---\n', threshold);
fprintf('%-40s %-17s %s\n', 'Trajektorie', 'Endwertfehler', 'J_dev=dev_init^2+dev_end^2');
for AP_init=1:4
    for AP_end=1:4
        if AP_init ~= AP_end            
            fprintf('%-40s %-17f %f\n', Selection(AP_init, AP_end).name, Selection(AP_init, AP_end).dev, Selection(AP_init, AP_end).J_dev);
        end
    end
end
end

