function animate_trajs_params(poi, poi_val, baseTrjName, searchPath, plotsPath)
% Animiert alle mit "Parameter of Interest" variierten Trajektorien

if exist('plotsPath', 'var')
    saving=true;
else
    saving=false;
end
l = length(poi_val);

% Animationsschleife
for i=1 : l   
    fileName = [baseTrjName '_' poi '_' num2str(poi_val(i))];     
    fullPath = fullfile(searchPath, fileName);
    try
        data = load([fullPath '.mat']);
        loadSuc = true;
    catch
        loadSuc = false;
        fprintf('%s konnte nicht geladen werden.\n', fileName)
    end

    if loadSuc  
        % Prüfen, ob Trajektorie eine "Optimal Solution", bzw. gültig ist.
        % Dann Animation und Plot, ggf. speichern.
        if isfield(data.results_traj, 'success')
            if data.results_traj.success
                if saving
                    plotanimate_traj(data, fileName, plotsPath)
                else
                    plotanimate_traj(data)
                end
            end
        elseif J<1
            if saving
                plotanimate_traj(data, fileName, plotsPath)
            else
                plotanimate_traj(data)
            end
        end
    end
end
end

