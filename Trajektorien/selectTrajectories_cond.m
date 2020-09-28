function selectTrajectories_cond(condition, savefiles, searchPath, destPath)
% Wählt Trajektorien aus, die die Condition erfüllen
% Euklidische Norm im Zielzustand muss kleiner sein als Condition

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
threshold = 1;

% Rekonstruktion des Dateinamens (definiert in trajectorySearch)
counter = zeros(4, 4);
fprintf('\n\n----------------gültige Trajektorien mit Endwertfehler<=%f----------------\n', condition);
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
            if norm(x_traj(:,1)-x_init, 2)<threshold    % Prüft Einhaltung des Anfangswerts
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

