% Macht Plots und Animationen für alle Trajektorien in einem Ordner

[nameList, ~, ~, ~] = getTrajFileNames();

% ACHTUNG --> "Selection"-Ordner auswählen, sonst werden es seeeehr viele Files
searchPath = 'Trajektorien\searchResults\Results_odeTesGeb_rib20_Mc_maxIt10000\Euler_MPC\Selection_Best_End';
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
        vT = 0 : trj.T : (trj.T)*(trj.N);
        y_traj = trj.results_traj.x_traj([1 3 5],:);
        x_traj = trj.results_traj.x_traj;
        u_traj = trj.results_traj.u_traj;
        mY = timeseries(y_traj, vT, 'Name', 'mY'); 
        mX = timeseries(x_traj, vT, 'Name', 'mX');
        vF = timeseries([u_traj; 0], vT, 'Name', 'vF');
        outTraj = tscollection({mY; mX; vF});
        fprintf('%s\n', filename)
    
%         plot_outputs(outTraj);
%         animate_outputs(outTraj);
%         plot_velocities(outTraj);
%         plot_outputs(outTraj, true, filename, plotsPath);
        animate_outputs(outTraj, 1, true, filename, plotsPath);
        hFigure = figure();
        for i=1:6
            subplot(6, 1, i)
            plot(vT, x_traj(i, :))
            title(['x', num2str(i)])
        end
        [~, name, ext] = fileparts(filename);
        exportgraphics(hFigure, ['Plots\' plotsPath '\' name '.png'], 'Resolution', 300);
    end

       

    
end