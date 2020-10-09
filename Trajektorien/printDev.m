function printDev(searchPath, nameExtension)
% Gibt Tabelle mit Trajektorien und Endwertfehlern in der Konsole aus

% Ordnerstruktur
if ~exist('searchPath', 'var')
    % Wähle Ordner mit Ergebnissen der Trajektorienberechnung
    subfolderPath1 = 'Trajektorien\searchResults';
    subfolderPath2 = 'Results_odeTesGeb_app09_T0.005N500';
    resFolderName = 'Rk4_MPC';
    searchPath = fullfile(subfolderPath1, subfolderPath2, resFolderName);
end
if ~exist('nameExtension', 'var') % Dateinamenkennzeichnung
    nameExtension = '';
end 

% Rekonstruktion des Dateinamens (definiert in trajectorySearch)
res.maxDev = 0;
res.maxDevInit = 0;
res.name = '';
fprintf('\n--- Fehlerinformationen zu allen Trajektorien ---\n')
fprintf('%-50s %-17s %-17s %-17s %s\n', 'Trajektorie', 'Anfangswertfehler', 'Endwertfehler', 'J_dev', 'success');
[nameList, x_init_List, ~, ~] = getTrajFileNames(nameExtension);
for k=1 : length(nameList)
    fileName = nameList{k};
    x_init = x_init_List(:, k);
    try
        data = load(fullfile(searchPath, fileName));
        loadSuc = true;
    catch
        %fprintf('%s existiert nicht in %s \n', fileName, searchPath);
        loadSuc = false;
    end 
    
    if loadSuc
        dev = data.results_traj.dev;
        x_traj = data.results_traj.x_traj;
        
        dev_init = norm(x_traj(:,1)-x_init, 2);
        dev_end = dev; % norm(x_traj(:,end)-Ruhelagen(AP_end).x, 2);
        J = dev_init + dev_end;
        if isfield(data.results_traj, 'success')
            success = data.results_traj.success;
        else
            success = NaN;
        end
        fprintf('%-50s %-17s %-17f %-17f %i\n',fileName, dev_init, dev_end, J, success);
        if dev_end > res.maxDev
            res.maxDev = dev_end;
            res.name = fileName;
        end
        if dev_init > res.maxDevInit
            res.maxDevInit = dev_init;
            res.name = fileName;
        end
    end
end
fprintf('Maximaler Endwertfehler\n');
fprintf('%-50s %f\n', res.name, res.maxDev);
fprintf('Maximaler Anfangswertfehler\n');
fprintf('%-50s %f\n', res.name, res.maxDevInit);


end

