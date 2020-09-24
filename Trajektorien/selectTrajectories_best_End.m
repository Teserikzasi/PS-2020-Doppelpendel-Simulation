function selectTrajectories_best_End(savefiles, searchPath, destPath)
% Wählt für jede der 12 gesuchten Trajektorien die Beste aus.
% Kriterium: Euklidische Norm im Zielzustand

% Ordnerstruktur
if ~exist('searchPath', 'var')
    % Wähle Ordner mit Ergebnissen der Trajektorienberechnung
    subfolderPath1 = 'Trajektorien\searchResults';
    subfolderPath2 = 'Results_odeTesGeb_app09_maxIt10000';
    resFolderName = 'Euler_MPC';
    searchPath = fullfile(subfolderPath1, subfolderPath2, resFolderName);
end
if ~exist('destPath', 'var') % Zielpfad
    destPath = fullfile(searchPath, 'Selection_Best_End');
end
if ~exist(destPath, 'dir')
    if savefiles
        mkdir(destPath);
    end
end

% initialisiere Auswahl
for AP_init=1:4
    for AP_end=1:4
        Selection(AP_init, AP_end) = struct('name', ['Traj' num2str(AP_init) num2str(AP_end)], 'dev', inf);
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

        if max( abs( x_traj(1, :) ) ) <= 0.7 % Prüft Einhaltung der Positionsbegrenzung
            if norm(x_traj(:,1)-x_init, 2)< threshold    % Prüft Einhaltung des Anfangswerts
                if dev < Selection(AP_init, AP_end).dev % Sucht nach kleinstem Endwertfehler/dev
                    Selection(AP_init, AP_end).dev = dev;
                    Selection(AP_init, AP_end).name = fileName;
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
fprintf('\n\n---Beste Trajektorien bezüglich Endwertfehler (Schwelle nur für Anfangswertfehler: %f)---\n', threshold);
fprintf('%-40s %s\n', 'Trajektorie', 'Endwertfehler/dev');
for AP_init=1:4
    for AP_end=1:4
        if AP_init ~= AP_end            
            fprintf('%-40s %f\n', Selection(AP_init, AP_end).name, Selection(AP_init, AP_end).dev);
        end
    end
end
end

