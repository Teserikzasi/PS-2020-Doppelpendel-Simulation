function plot_Jdev_params(poi, poi_val, baseTrjName, searchPath, xScale, plotsPath)
% Plottet Fehlersumme aus Anfangs- und Endwertfehler einer
% Trajektorie in Abhängigkeit eines "Parameter of Interest"

if exist('plotsPath', 'var')
    saving=true;
else
    saving=false;
end

app09 = SchlittenPendelParams_Apprich09();
rib20 = SchlittenPendelParams_Ribeiro20();

% Apprich in Daten einsortieren
new_poi_val = [];
offset = 0;
done = false;
for j=1:length(poi_val)
    if ~done
        if poi_val(j)>app09.(poi)
            new_poi_val(j)=app09.(poi);
            done = true;
            offset=offset+1;
            new_poi_val(j+offset) = poi_val(j);  
        elseif poi_val(j)==app09.(poi)
            done = true;
            new_poi_val(j) = poi_val(j);
        else
            new_poi_val(j) = poi_val(j);
        end
    else
        new_poi_val(j+offset) = poi_val(j);
    end    
end
poi_val = new_poi_val;
% Ribeiro in Daten einsortieren
new_poi_val = [];
offset = 0;
done = false;
for j=1:length(poi_val)
    if ~done
        if poi_val(j)>rib20.(poi)
            new_poi_val(j)=rib20.(poi);
            done = true;
            offset=offset+1;
            new_poi_val(j+offset) = poi_val(j); 
        elseif poi_val(j)==rib20.(poi)
            done = true;
            new_poi_val(j) = poi_val(j);
        else
            new_poi_val(j) = poi_val(j);
        end
    else
        new_poi_val(j+offset) = poi_val(j);
    end    
end
poi_val = new_poi_val;

% Läd die parametervariierten Trajektorien
l = length(poi_val);
ylab = "J_{dev}";
xlab = poi;
vJ_devs = [];
vPoi = poi_val;
cnt = 0;
for i=1 : l  
    fileName = [baseTrjName '_' poi '_' num2str(poi_val(i))]; 
    fullPath = fullfile(searchPath, fileName);
    try
        data = load([fullPath '.mat']);
        loadSuc = true;
        fprintf('%s geladen.\n', fileName)
    catch
        if poi_val(i)==app09.(poi) || poi_val(i)==rib20.(poi)
            fileName = baseTrjName; 
            fullPath = fullfile(searchPath, fileName);
            try
                data = load([fullPath '.mat']);
                loadSuc = true;
                fprintf('%s geladen.\n', fileName)
            catch
                loadSuc = false;
                fprintf('%s konnte nicht geladen werden.\n', fileName)
            end
        else
            loadSuc = false;
            fprintf('%s konnte nicht geladen werden.\n', fileName)
        end        
    end

    if loadSuc
        x_traj = data.results_traj.x_traj;
        x_init = data.x_init;
        x_end = data.x_end;
        dev_init = norm(x_traj(:,1)-x_init, 2);
        dev_end = norm(x_traj(:,end)-x_end);
        J = dev_init + dev_end;
        
        % Prüfen, ob Trajektorie eine "Optimal Solution", bzw. gültig ist,
        % sonst aussortieren
        if isfield(data.results_traj, 'success')
            if data.results_traj.success
                vJ_devs(i-cnt) = J;
            else
                vPoi(i-cnt) = [];
                cnt = cnt + 1;
            end
        elseif J<1 
            vJ_devs(i-cnt) = J;
        else
            vPoi(i-cnt) = [];
            cnt = cnt + 1;
        end
    end
end

% Plot
hFigure = figure();
grid on
hold on
% Plottet interpolierte Jdev-Werte der gültigen Trajektorien
if length(vJ_devs)>1
    J_interp = interp1(vPoi, vJ_devs, poi_val, 'linear', nan);
    plot(poi_val, J_interp)
elseif length(vJ_devs)==1
    plot(vPoi, vJ_devs)
else 
    disp('Keine der Trajektorien ist gültig.')
end
% Markiert Stützwerte (Apprich09 grün, Ribeiro20 magenta, sonst blau)
for k=1 : length(vPoi)
    if vPoi(k) == app09.(poi)
        plot(vPoi(k), vJ_devs(k), 'o', 'Color', 'g', 'LineWidth', 2) 
    elseif vPoi(k) == rib20.(poi)
        plot(vPoi(k), vJ_devs(k), 'o', 'Color', 'm', 'LineWidth', 2)
    else
        plot(vPoi(k), vJ_devs(k), 'o', 'Color', '#0072BD', 'LineWidth', 1)
    end    
end
% Plottet ungültige Trajektorien (Infeasability-Konvergenz) als rotes X auf
% der Abzisse
for k=1 : l
    if ~ismember(poi_val(k), vPoi)
        if poi_val(k) == app09.(poi)
            plot(poi_val(k), 0, 'x', 'Color', 'g', 'LineWidth', 2)
        elseif poi_val(k) == rib20.(poi)
            plot(poi_val(k), 0, 'x', 'Color', 'm', 'LineWidth', 2)
        else
            plot(poi_val(k), 0, 'x', 'Color', 'r', 'LineWidth', 1)
        end
        
    end
end
if exist('xScale', 'var')
    xticks(xScale)
end
ylabel(ylab)
xlabel(xlab)
title(['Trajektorienfehler - Variation: ' poi])

% speichern
if saving
    filename = [baseTrjName '_Jdevs_' poi];
    folderPath = fullfile('Plots', plotsPath);
    fullPath = fullfile(folderPath, [filename '.png']);
    if ~exist(folderPath, 'dir')
        mkdir(folderPath)
    end
    exportgraphics(hFigure, fullPath, 'Resolution', 300);
    fprintf('Plot gespeichert unter %s\n', fullPath)
end

end

