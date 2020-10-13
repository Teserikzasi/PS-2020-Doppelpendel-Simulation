function examParameters(poi, poi_val, N, T, simSol, params, u_max)

%% Speicherordner
fullFolderPath = fullfile('Trajektorien', ['ParameterExams_' paramsSource]);

%% Durchführung der Versuchsreihe
for i=1 : length(poi_val)
    if isfield(params, poi)
        params.(poi) = poi_val(i);
    else
        disp('Versuchsparameter ist kein gültiger Schlittenpendelparameter')
        return
    end
    selectSuccess = false; % auch nicht Optimale Lösungen speichern für Plots
    mode = 1; % Modus "Vergleichstrajektorie"
    coulMc = false;
    coulFc = false;
    nameExtension = ['_' convertStringsToChars(poi) '_' num2str(poi_val(i))];
    searchTrajectories(mode, N, T, simSol, params, u_max, coulMc, coulFc, selectSuccess, nameExtension, fullFolderPath)
end
end

