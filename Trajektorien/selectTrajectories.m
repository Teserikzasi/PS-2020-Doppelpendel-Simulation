function selectTrajectories(mode, searchPath, nameExtension, savefiles, destPath, condition)
% Wählt für jede der 12 gesuchten Trajektorien die Beste aus.
% Kriterium: Euklidische Norm im Zielzustand und im Anfangszustand
% mode:
% 1=Optimal Solution Found
% 2=Beste Trajektorien
% 3=Trajektorien mit Fehler kleiner als condition [Default: 0.01]

% Ordnerstruktur
if ~exist('searchPath', 'var')
    % Wähle Ordner mit Ergebnissen der Trajektorienberechnung
    subfolderPath1 = 'Trajektorien\searchResults';
    subfolderPath2 = 'Results_odeTesGeb_app09_T0.005N500';
    resFolderName = 'Rk4_MPC';
    searchPath = fullfile(subfolderPath1, subfolderPath2, resFolderName);
end
if ~exist('nameExtension', 'var') % Filenamenkennzeichnung
    nameExtension = '';
end 
if ~exist('savefiles', 'var') % Speicheroption
    savefiles = false;
end
if ~exist('destPath', 'var') % Zielpfad
    destPath = fullfile(searchPath, 'Selection');
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

% initialisiere Auswahl
if mode==3 || mode==1
    for j=1 : 640
        Selection(j) = struct('name', '', 'J_dev', inf, 'dev', inf, 'dev_init', inf);
    end
    i = 1;
else
    for AP_init=1:4
        for AP_end=1:4
            Selection(AP_init, AP_end) = struct('name', ['Traj' num2str(AP_init) num2str(AP_end)], 'J_dev', inf, 'dev_end', inf, 'dev_init', inf, 'success', inf);
        end
    end
end

% Iteration über Trajektoriennamensliste
counter = zeros(4, 4);
cnt_all = 0;
[nameList, x_init_List, AP_init_List, AP_end_List] = getTrajFileNames(nameExtension);
for k=1 : length(nameList)
    fileName = nameList{k};
    x_init = x_init_List(:, k);
    AP_init = AP_init_List(k);
    AP_end = AP_end_List(k);
    % file laden
    try
        data = load(fullfile(searchPath, fileName));
        loadSuc = true;
        cnt_all=cnt_all+1;
    catch
        %fprintf('%s existiert nicht in %s \n', fileName, searchPath);
        loadSuc = false;
    end  
    % Selektion
    if loadSuc
        dev = data.results_traj.dev;
        x_traj = data.results_traj.x_traj;
        dev_init = norm(x_traj(:,1)-x_init, 2);
        dev_end = dev; % norm(x_traj(:,end)-Ruhelagen(AP_end).x, 2);
        J = dev_init + dev_end;
        if isfield(data.results_traj, 'success')
            success = data.results_traj.success;
        else 
            disp('"Success"-Feld in Trajektorien fehlt.')
            return
        end
        switch mode
            case 1 % Optimal Solution Found
                if data.results_traj.success
                    Selection(i).name = fileName;
                    Selection(i).dev_end = dev;
                    Selection(i).dev_init = dev_init;
                    Selection(i).J_dev = J;
                    Selection(i).success = success;
                    counter(AP_init, AP_end) = counter(AP_init, AP_end) + 1;
                    i=i+1;
                end
            case 2 % Beste 12 Trajektorien
                if data.results_traj.success  
                    if max( abs( x_traj(1, :) ) ) <= 0.8
                        if  J < Selection(AP_init, AP_end).J_dev
                            Selection(AP_init, AP_end).J_dev = J;
                            Selection(AP_init, AP_end).name = fileName;
                            Selection(AP_init, AP_end).dev_end = dev_end;
                            Selection(AP_init, AP_end).dev_init = dev_init;
                            Selection(AP_init, AP_end).success = success;
                        end
                    end
                end
            case 3 % Gesamtfehler kleiner als Schwelle
                if data.results_traj.success 
                    % Wenn Genauigkeitsbedingung erfüllt, dann speichern
                    if J <= condition 
                        Selection(i).name = fileName;
                        Selection(i).dev_end = dev;
                        Selection(i).dev_init = dev_init;
                        Selection(i).J_dev = J;
                        Selection(i).success = success;
                        counter(AP_init, AP_end) = counter(AP_init, AP_end) + 1;
                        i=i+1;
                    end
                end
            case 4 % keine Selektion, nur Infos anzeigen
        end
  
    end
end
            
% Speichert Auswahl
if savefiles
    if mode==1 || mode==3
        for j=1 : 640
            fileName = Selection(j).name;               
            try
               data = load(fullfile(searchPath, fileName));
               filePath = fullfile(destPath, fileName);
               save(filePath, '-struct', 'data');
            catch
               if ~isempty(fileName)
                   fprintf('%s existiert nicht in %s \n', fileName, searchPath);
               end
            end
        end
    else
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
    end
    %fprintf('Auswahl wurde gespeichert unter %s.\n\n', destPath);
else
    %fprintf('Auswahl wurde nicht gespeichert.\n\n');
end

% Zeige Ergebnis an
switch mode
    case 1
        fprintf('\n\n----------------"Optimal Solution Found" - Trajektorien ----------------\n');
        fprintf('%-50s %-17s %-17s %-17s %s\n', 'Trajektorie', 'Anfangswertfehler', 'Endwertfehler', 'J_dev', 'success');
        for n=1 : i-1
            fprintf('%-50s %-17s %-17f %-17f %i\n', Selection(n).name, Selection(n).dev_init, Selection(n).dev_end, Selection(n).J_dev, Selection(n).success);
        end
        fprintf('\nGesamt: %i von %i\n\n', i-1, cnt_all);
    case 2
        fprintf('\n\n----------------Beste Trajektorien (Positionsbegrenzung berücksichtigt)----------------\n');
        fprintf('%-50s %-17s %-17s %-17s %s\n', 'Trajektorie', 'Anfangswertfehler', 'Endwertfehler', 'J_dev', 'success');
        for AP_init=1:4
            for AP_end=1:4
                if AP_init ~= AP_end            
                    fprintf('%-50s %-17s %-17f %-17f %i\n', Selection(AP_init, AP_end).name, Selection(AP_init, AP_end).dev_init, Selection(AP_init, AP_end).dev_end, Selection(AP_init, AP_end).J_dev,  Selection(AP_init, AP_end).success);
                end
            end
        end
    case 3
        fprintf('\n\n----------------Trajektorien mit Gesamtfehler J<=%f----------------\n', condition);
        fprintf('%-50s %-17s %-17s %-17s %s\n', 'Trajektorie', 'Anfangswertfehler', 'Endwertfehler', 'J_dev', 'success');
        for n=1 : i-1
            fprintf('%-50s %-17s %-17f %-17f %i\n', Selection(n).name, Selection(n).dev_init, Selection(n).dev_end, Selection(n).J_dev, Selection(n).success);
        end
        fprintf('\nErgebnis\n');
        for AP_init=1:4
            for AP_end=1:4
                if AP_init ~= AP_end
                    fprintf('Traj%i%i: %i\n', AP_init, AP_end, counter(AP_init, AP_end));
                end
            end
        end
        fprintf('Gesamt: %i von %i\n\n', sum(counter, 'all'), cnt_all);
    case 4
        printDev(searchPath, nameExtension)
end

end

