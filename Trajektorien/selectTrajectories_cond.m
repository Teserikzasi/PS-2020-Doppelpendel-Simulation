function selectTrajectories_cond(condition, savefiles, searchPath, destPath)
% Wählt Trajektorien aus, die die Condition erfüllen
% Euklidische Norm im Zielzustand muss kleiner sein als Condition
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
    destPath = fullfile(searchPath, 'Selection_Cond');
end
if ~exist(destPath, 'dir')
    if savefiles
        mkdir(destPath);
    end
end

% Condition
if ~exist('condition', 'var')
    condition = 0.01;
end

% Rekonstruktion des Dateinamens (definiert in trajectorySearch)
[dev_x0, dev_AP_phi1, dev_AP_phi2] = getInitDev(); 
counter = zeros(4, 4);
fprintf('\n\n----------------Trajektorien mit dev<=%f----------------\n', condition);
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
                    if max( abs( x_traj(1, :) ) ) <= 0.7 % Prüft Einhaltung der Positionsbegrenzung
                        if norm(x_traj(:,1)-x_init, 2)<1    % Prüft Einhaltung des Anfangswerts
                            % Wenn Genauigkeitsbedingung erfüllt, dann speichern
                            if dev <= condition 
                                if savefiles
                                    filePath = fullfile(destPath, fileName);                       
                                    save(filePath, '-struct', 'data');   
                                end
                                counter(AP_init, AP_end) = counter(AP_init, AP_end) + 1;
                                fprintf('%s\n', fileName);
                            end
                        end
                    end
                end                                                 
            end
        end
    end
end
% if savefiles
%     fprintf('Auswahl wurde gespeichert unter %s.\n\n', destPath);
% else
%     fprintf('Auswahl wurde nicht gespeichert.\n\n');
% end

% Zeige Ergebnis an
fprintf('\nErgebnis\n');
for AP_init=1:4
    for AP_end=1:4
        if AP_init ~= AP_end
            fprintf('Traj%i%i: %i\n', AP_init, AP_end, counter(AP_init, AP_end));
        end
    end
end
fprintf('Gesamt: %i\n', sum(counter, 'all'));
end

