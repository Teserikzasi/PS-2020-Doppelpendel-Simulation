function plot_outputs(out, motorParams, save, name, path, format, resolution)
    % Erstellt Subplots von x, phi1 und phi2
    % Die Funktion bekommt als Argument "out" die über ToWorkspace
    % in den Base Workspace abgelegten Ausgänge des Simulink Modells. 
    % "out" ist eine Struktur, die das Feld "mY" aufweisen muss.
    % "mY" wiederum enthält die aufgezeichnete Timeseries-Struktur mit 
    % den Simulationswerten (in ToWorkspace-Block "Timeseries" einstellen)
    % 
    % Optionale Argumente, um Plot abzuspeichern:
    %
    % motorParams = Struktur.staticGain (Default: 1.87*0.153*60/16/0.0255)
    % save = Boolean (Default: false)
    % name = Dateiname (Default: yyyy-MM-dd_HH-mm-ss_plot)
    % path = Dateipfad (Default: \Plots)
    % format = Bildformat (Default: .png)
    % resolution = Grafikauflösung in DPI (Default: 300)
    
    %% Daten und Parameter
    x1 = squeeze(out.mY.Data(1, 1, :));    
    phi1 = squeeze(out.mY.Data(2, 1, :));    
    phi2 = squeeze(out.mY.Data(3, 1, :));   
    stellF = squeeze(out.vF.Data);
    stellU = squeeze(out.vU.Data);
    
    % Prüfe, ob Beobachterschätzwerte vorhanden
    if ismember('x_est', out.who)
        estExist = true;
        x1_est = squeeze(out.x_est.Data(1, 1, :));
        phi1_est = squeeze(out.x_est.Data(3, 1, :));
        phi2_est = squeeze(out.x_est.Data(5, 1, :));
    else
        estExist = false;
    end
    
    % Static Gain
    if ~exist('motorParams', 'var')
        staticGain = 1.87*0.153*60/16/0.0255; % Default
    else
        staticGain = motorParams.staticGain;
    end
    
    %% Plot
    hFig = figure();
    
    subplot(4,1,1);       
	plot(out.mY.Time, x1, 'Color', [0 0.4470 0.7410], 'LineWidth', 1);  
    hold on;
    title('Position x');
	ylabel('x [m]');
    if estExist
        plot(out.mY.Time, x1_est, 'Color', [0.3010, 0.7450, 0.9330], 'LineWidth', 1);
        legend('x', 'x_{est}');
    end
       
    grid on;
    
    subplot(4,1,2);    
    plot(out.mY.Time, phi1*180/pi, 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1);
    hold on;	
    title('Winkel \phi_{1}')
	ylabel('\phi_{1} [grad]');
    if estExist
        plot(out.mY.Time, phi1_est*180/pi, 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 1);
        legend('\phi_{1}', '\phi_{1-est}'); 
    end   
    grid on;
    
    subplot(4,1,3);
    plot(out.mY.Time, phi2*180/pi, 'Color', [0.4940, 0.1840, 0.5560], 'LineWidth', 1);   
    hold on;	
    title('Winkel \phi_{2}')
	ylabel('\phi_{2} [grad]');
    if estExist
        plot(out.mY.Time, phi2_est*180/pi, 'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 1);
        legend('\phi_{2}', '\phi_{2-est}'); 
    end    
    grid on;
    
    subplot(4,1,4);
    plot(out.mY.Time, stellU*staticGain, 'Color', [0.8, 0.0780, 0.1840], 'LineWidth', 1);
    hold on;
 	plot(out.mY.Time, stellF, 'Color', [0.3, 0.5, 0.9], 'LineWidth', 1);   
    title('Sollkraft F_{soll} und Kraftausgang F_{out}');
	ylabel('F [N]');
    legend('F_{soll}', 'F_{out}');
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
    filePath = 'Plots';
    fileFormat = '.png';
    fileReso = 300;
    % Argumente prüfen        
    if exist('save', 'var')
        fileSave = save;
    end
    if exist('name', 'var')
        fileName = name;
    end 
    if exist('path', 'var')
        filePath = [filePath '\' path];
    end
    if exist('format', 'var')
        fileFormat = format;
    end
    if exist('resolution', 'var')
        fileReso = resolution;
    end
    
    % speichern
    if fileSave
        exportgraphics(hFig, [filePath '\' fileName fileFormat], 'Resolution', fileReso);
    end
end