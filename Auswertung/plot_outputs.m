function plot_outputs(out, save, name, path, format, resolution)
    % Erstellt Subplots von x, phi1 und phi2
    % Die Funktion bekommt als Argument "out" die über ToWorkspace
    % in den Base Workspace abgelegten Ausgänge des Simulink Modells. 
    % "out" ist eine Struktur, die das Feld "mY" aufweisen muss.
    % "mY" wiederum enthält die aufgezeichnete Timeseries-Struktur mit 
    % den Simulationswerten (in ToWorkspace-Block "Timeseries" einstellen)
    % 
    % Optionale Argumente, um Plot abzuspeichern:
    %
    % save = Boolean (Default: false)
    % name = Dateiname (Default: yyyy-MM-dd_HH-mm-ss_plot)
    % path = Dateipfad (Default: \Plots)
    % format = Bildformat (Default: .png)
    % resolution = Grafikauflösung in DPI (Default: 300)
    
    %% Data konvertieren von 3D zu 1D
    x1 = squeeze(out.mY.Data(1, 1, :))';
    phi1 = squeeze(out.mY.Data(2, 1, :))';
    phi2 = squeeze(out.mY.Data(3, 1, :))';
    stellF = squeeze(out.vF.Data(1, 1, :))';
    stellU = (out.vU.Data)';   
    
    %% Plot
    hFig = figure();
    
    subplot(5,1,1);
	plot(out.mY.Time, x1, 'Color', [0 0.4470 0.7410], 'LineWidth', 1);
    title('Position x');
	ylabel('x [m]');    
    grid on;
    
    subplot(5,1,2);
	plot(out.mY.Time, phi1, 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1);
    title('Winkel \phi_{1}')
	ylabel('\phi_{1} [rad]');
    grid on;
    
    subplot(5,1,3);
	plot(out.mY.Time, phi2, 'Color', [0.9290 0.6940 0.1250], 'LineWidth', 1);
    title('Winkel \phi_{2}')
	ylabel('\phi_{2} [rad]');
    grid on;
    
    subplot(5,1,4);
	plot(out.mY.Time, stellF, 'Color', [0.3010 0.7450 0.9330], 'LineWidth', 1);
    title('Kraft F');
	ylabel('F [N]');
    grid on;
    
    subplot(5,1,5);
	plot(out.mY.Time, stellU, 'Color', [0.4940 0.1840 0.5560], 'LineWidth', 1);
    title('Spannung U');
	ylabel('U [V]');
    grid on;
    
    xlabel('Zeit t [s]');
    
    %% Plot speichern
    if nargin==1
        return
    end
    % Default-Konfiguration
    currDate = datetime();
    currDate.Format = 'yyyy-MM-dd_HH-mm-ss';
    fileName = [char(currDate) '_' 'plot'];
    fileSave = false;    
    filePath = fullfile(cd(), 'Plots');
    fileFormat = '.png';
    fileReso = 300;
    % Argumente prüfen        
    if nargin>1
        fileSave = save;
        if nargin>2
            fileName = name;
            if nargin>3
                filePath = path;
                if nargin>4
                    fileFormat = format;
                    if nargin==6
                        fileReso = resolution;
                    end
                end
            end
        end
    end
    % speichern
    if fileSave
        exportgraphics(hFig, [filePath '\' fileName fileFormat], 'Resolution', fileReso);
    end
end