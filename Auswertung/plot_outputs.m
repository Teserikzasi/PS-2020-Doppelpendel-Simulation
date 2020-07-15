function plot_outputs(out, save, name, path, format, resolution)
    % Erstellt Subplots von x, phi1 und phi2
    %
    % Optionale Argumente, um Plot abzuspeichern:
    %
    % save = Boolean (Default: false)
    % name = Dateiname (Default: yyyy-MM-dd_HH-mm-ss_plot)
    % path = Dateipfad (Default: \Plots)
    % format = Bildformat (Default: .png)
    % resolution = Grafikauflösung in DPI (Default: 300)
    
    %% Data konvertieren von 3D zu 1D
    x1 = [];
    phi1 = [];
    phi2 = [];
    for i=1:length(out.mY.Data(1,1,:))
       x1(i) = out.mY.Data(1, 1, i);
       phi1(i) = out.mY.Data(2, 1, i);
       phi2(i) = out.mY.Data(2, 1, i);
    end
    
    %% Plot
    fgh = figure();
    
    subplot(3,1,1);
	plot(out.mY.Time, x1, 'Color', [0 0.4470 0.7410]);
    title('Position x');
	ylabel('x [m]');
    axis equal
    
    subplot(3,1,2);
	plot(out.mY.Time, phi1, 'Color', [0.8500 0.3250 0.0980]);
    title('Winkel \phi_{1}')
	ylabel('\phi_{1} [rad]');
    axis equal
    
    subplot(3,1,3);
	plot(out.mY.Time, phi2, 'Color', [0.9290 0.6940 0.1250]);
    title('Winkel \phi_{2}')
	ylabel('\phi_{2} [rad]');
    axis equal
    
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
        exportgraphics(fgh, [filePath '\' fileName fileFormat], 'Resolution', fileReso);
    end
end