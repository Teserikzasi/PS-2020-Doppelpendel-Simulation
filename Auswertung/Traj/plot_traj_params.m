function plot_traj_params(poi, poi_val, baseTrjName, searchPath, plotsPath)
% Plottet alle Trajektorien in eine Darstellung 

if exist('plotsPath', 'var')
    saving=true;
else
    saving=false;
end
l = length(poi_val);

%Daten laden
T = [];
X_traj = [];
U_traj = [];
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
        % Trajektoriendaten in Simulinkoutput-Format konvertieren
        vT = 0 : data.T : (data.T)*(data.N);
        T(i,:) = vT;
        X_traj(i,:,:) = data.results_traj.x_traj;
        U_traj(i,:,:) = data.results_traj.u_traj;    
    end
end

ylab = ["x_0 [m]", "\phi_{1} [°]","\phi_{2} [°]", "F [N]"];
xlab = "t [s]";
set(groot, 'DefaultTextInterpreter', 'tex')
hFigure = figure();
set(hFigure,'units','normalized','outerposition',[0 0 1 1]) % fullsize

% subplot nur für Legende
hSub = subplot(5, 1, 1); 
grid on
hold on
for i=1 : l
    plot(T(i,:), nan);
end
set(hSub, 'Visible', 'off');
legend(string(poi_val), 'location', 'bestoutside')

% Plots
for k=2:4
    subplot(5, 1, k)
    grid on
    hold on
    for i=1 : l
        plot(T(i,:), squeeze(X_traj(i, 2*(k-1)-1, :)), 'LineWidth', 0.9)
    end
    if k==2
        title(['Trajektorien - Variation: ' poi])
    end
    ylabel(ylab(k))
end
subplot(5, 1, 5)
grid on
hold on
for i=1 : l
    plot(T(i,:), [U_traj(i,:), 0])
end
ylabel(ylab(4))    

xlabel(xlab)

% speichern
if saving
    filename = [baseTrjName '_trajs_' poi];
    exportgraphics(hFigure, ['Plots\' plotsPath '\' filename  '.png'], 'Resolution', 300);
end


end

