function selectTrajectories_best_InitEnd(savefiles, searchPath, destPath)
% Wählt für jede der 12 gesuchten Trajektorien die Beste aus.
% Kriterium: Euklidische Norm im Zielzustand und Anfangszustand

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

% Iteration über Trajektoriennamensliste
[nameList, x_init_List, AP_init_List, AP_end_List] = getTrajFileNames();
for k=1 : length(nameList)
    fileName = nameList{k};
    x_init = x_init_List(:, k);
    AP_init = AP_init_List(k);
    AP_end = AP_end_List(k);
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
                    if  J < Selection(AP_init, AP_end).J_dev % Sucht nach kleinster euklidischer Norm aus Endwert- und Anfangswertfehler
                        Selection(AP_init, AP_end).J_dev = J; %sqrt(dev_end^2+dev_init^2);
                        Selection(AP_init, AP_end).name = fileName;
                        Selection(AP_init, AP_end).dev = dev_end;
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
fprintf('%-40s %-17s %s\n', 'Trajektorie', 'Endwertfehler', 'J_dev=sqrt(dev_end^2+dev_init^2)');
for AP_init=1:4
    for AP_end=1:4
        if AP_init ~= AP_end            
            fprintf('%-40s %-17f %f\n', Selection(AP_init, AP_end).name, Selection(AP_init, AP_end).dev, Selection(AP_init, AP_end).J_dev);
        end
    end
end
end

