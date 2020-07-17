function animate_outputs(out,spParams)
    % Plottet Animation des Schlittendoppelpendels
    %   ...

    %% Parameter der Animation
    nFrames = length(out.mY.Time); % Anzahl aller Frames
    startTime = out.mY.Time(1); % Startzeit der Simulation
    stopTime = out.mY.Time(end); % Stopzeit der Simulation
    duration = stopTime - startTime;
    tSample = duration/(nFrames-1); % Abtastzeit in Simulation (ToWorkflow)
    fps = 1/tSample; % Frames per second
    
    loopTime = 0.005; % mittlere Rechenzeit der for-Schleife pro Zyklus
    
    l1 = spParams.l1;
    l2 = spParams.l2;
    
    %% Ortsvektoren
    % Data konvertieren von 3D zu 1D
    x1 = zeros(1, nFrames);
    phi1 = zeros(1, nFrames);
    phi2 = zeros(1, nFrames);
    for k=1:nFrames
       x1(k) = out.mY.Data(1, 1, k);
       phi1(k) = out.mY.Data(2, 1, k);
       phi2(k) = out.mY.Data(3, 1, k);
    end 
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
    for f = 1:nFrames 
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

        % Samplezeit bei Wiedergabe berücksichtigen (Pro Schleife ein Sample)
        pause(tSample - loopTime);
    end
    
    hold(hAxes, 'off');
    
    
    
end

