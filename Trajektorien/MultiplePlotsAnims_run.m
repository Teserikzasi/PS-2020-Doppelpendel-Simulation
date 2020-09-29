% Macht Plots und Animationen für alle Trajektorien in einem Ordner

[nameList, ~, ~, ~] = getTrajFileNames();

% ACHTUNG --> "Selection"-Ordner auswählen, sonst werden es seeeehr viele Files
searchPath = 'Trajektorien\searchResults\Results_odeTesGeb_app09_maxIt10000\RK4_MPC\Selection_Best_InitEnd';
plotsPath = 'Trajektorien_Tests';

for k=1 : length(nameList)
    filename = nameList{k};
        
    fullPath = fullfile(searchPath, filename);
    try
        trj = load(fullPath);
        loadSuc = true;
    catch
        loadSuc = false;
    end
    
    if loadSuc
        [~, name, ~] = fileparts(filename);
        plotanimate_traj(trj, name, plotsPath)
    end   
end