function animate_outputs(out, SchlittenPendelParams, speedFactor, save, name, path)
    % Animiert Schlittendoppelpendel in realer Wiedergabezeit oder erstellt
    % ein Videofile im avi-Format. 
    % "out" ist eine Struktur, die das Feld "mY" aufweisen muss.
    % "mY" wiederum enthält die aufgezeichnete Timeseries-Struktur mit 
    % den Simulationswerten (in ToWorkspace-Block "Timeseries" einstellen)
    % 
    % Optionale Argumente, um Animation als .avi abzuspeichern:
    %
    % SchlittenpendelParams = Struktur mit l1 und l2 (Default l1=l2=1)   
    % speedFactor = Wiedergabegeschwindigkeitsfaktor (Default: 1 [Echtzeit])
    % save = Boolean (Default: false)
    % name = Dateiname (Default: yyyy-MM-dd_HH-mm-ss_plot)
    % path = Dateipfad (Default: \Plots)
    
    %% Parameter der Animation
    nFrames = length(out.mY.Time); % Anzahl aller Frames
    startTime = out.mY.Time(1); % Startzeit der Simulation
    stopTime = out.mY.Time(end); % Stopzeit der Simulation
    duration = stopTime - startTime;
    tSample = duration/(nFrames-1); % Abtastzeit in Simulation (ToWorkflow)
    fps = 1/tSample; % Framerate in Frames per second    
    
    % Faktor der Wiedergabegeschwindigkeit (1=Echtzeitwiedergabe)
    if ~exist('speedFactor', 'var') || isempty(speedFactor)  % was ist eig var?
        speedFactor= 1; % Default
    end
             
    % Pendelparameter
    if ~exist('SchlittenPendelParams', 'var') || isempty(SchlittenPendelParams)
        l1 = 1;
        l2 = 1;
    else
        l1 = SchlittenPendelParams.l1;
        l2 = SchlittenPendelParams.l2;
    end
    
    %% Prüfe Save-Argument
    if ~exist('save', 'var')
        fileSave = false; % Default
    else
        fileSave = save;
    end
    % Falls Animation gespeichert werden soll, reserviere Speicher
    if fileSave
        animatedFrames = struct('cdata', cell(1, nFrames), ...
                                'colormap', cell(1, nFrames));
    end
    
    %% Ortsvektoren
    % Data konvertieren von 3D zu 1D
    x1 = squeeze(out.mY.Data(1, 1, :))';
    phi1 = squeeze(out.mY.Data(2, 1, :))';
    phi2 = squeeze(out.mY.Data(3, 1, :))';
    
    % Ortsvektoren berechnen
    xStab1Head = x1 - l1 * sin(phi1);
    yStab1Head = l1 * cos(phi1);
    xStab2Head = xStab1Head - l2 * sin(phi2);
    yStab2Head = yStab1Head + l2 * cos(phi2);

    %% Achsenbegrenzung
    xmax = max([x1 xStab1Head xStab2Head]);
    xmin = min([x1 xStab1Head xStab2Head]);
    ymax = l1 + l2;
    axRange = [xmin-0.1 xmax+0.1 -ymax-0.1 ymax+0.1];

    %% Achsen initialisieren
    hFig = figure();
    hAxes = axes();
    axis(axRange);
    xlabel('x [m]');
    ylabel('y [m]');
    set(hAxes, 'DataAspectRatio', [1 1 1]);
    hold(hAxes, 'on');

    %% Ausgangslage zeichnen
    plot(hAxes, ...
        [x1(1) xStab1Head(1)], ...
        [0 yStab1Head(1)], ...
        [xStab1Head(1) xStab2Head(1)], ...
        [yStab1Head(1) yStab2Head(1)]);

    %% Animation
    % loopTime = 0.005; % ungefähre Rechenzeit der for-Schleife pro Zyklus
    try  % falls Fenster geschlossen wird
    for f = 1:nFrames 
        tic
        % Title mit Echtzeit-Informationen zu Zeit, fps und Frames
        infoTitle = ['t = ' num2str( (f-1) * tSample, '%05.2f') ' sec ', ...
                        '(fps = ' num2str(fps) ', ' ...
                        'Frame ' num2str(f) '/' num2str(nFrames) ')'];
        title (hAxes, infoTitle); 

        % Im ersten Frame die Plots erstellen, danach plots aktualisieren
        xCart = x1(f);
        if(f==1)
            % Schlitten in schwarz
            vhCart = rectangle('Position', ...
                                [xCart-0.08 -0.05 0.16 0.1], ...
                                'FaceColor', 'k');
            % Pendel 1 in rot
            vhStab1 = plot(hAxes, ...
                                [x1(f) xStab1Head(f)], ...
                                [0 yStab1Head(f)], ...
                                'Color', 'r', 'LineWidth', 5);
            % Pendel 2 in blau
            vhStab2 = plot(hAxes, ...
                                [xStab1Head(f) xStab2Head(f)], ...
                                [yStab1Head(f) yStab2Head(f)], ...
                                'Color', 'b', 'LineWidth', 3);
        else
            set(vhCart, ...
                'Position', [xCart-0.08 -0.05 0.16 0.1]);
            set(vhStab1, ...
                'Xdata', [x1(f) xStab1Head(f)], ...
                'Ydata', [0 yStab1Head(f)]);
            set(vhStab2, ...
                'Xdata', [xStab1Head(f) xStab2Head(f)], ...
                'Ydata', [yStab1Head(f) yStab2Head(f)]);

            % Weg der Pendelspitze weiterzeichnen (kumulierte Linienplots)
            plot(hAxes, ...
                xStab2Head(f-1:f), yStab2Head(f-1:f), 'g');
        end
                
        % optionales Speichern
        if fileSave
            % Frames abspeichern 
            animatedFrames(f) = getframe(hFig);
        else
            % Absolutzeitwiedergabe 
            loopTime = toc;
            waitTime = (tSample - loopTime)/speedFactor;
            pause(waitTime);
        end
        
    end
    
    hold(hAxes, 'off');
    catch
        disp("Fenster vor Animationsende geschlossen")
    end
    
    %% Speichern der Animation   
    if fileSave 
        % Name und Dateipfad spezifizieren
        currDate = datetime();
        currDate.Format = 'yyyy-MM-dd_HH-mm-ss';
        fileName = [char(currDate) '_' 'Animation'];
        filePath = 'Plots';
        
        if exist('name', 'var')
            fileName = name;
        end       
        if exist('path', 'var')
            filePath = [filePath '\' path];
        end
        
        % Speichern mit korrekter Framerate
        v = VideoWriter([filePath '\' fileName '.avi']);
        v.FrameRate = fps;
        open(v);
        writeVideo(v, animatedFrames);
        close(v)
    end
    
end

