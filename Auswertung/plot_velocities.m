function plot_velocities(out, save, name, path, format, resolution)
    % Erstellt Subplots von x, phi1 und phi2
    % "out" beinhaltet die Simulationsergebnisse, die mit
    % ToWorskspace-Blöcken in den Base-Workspace geschrieben wurden
    % 
    % Optionale Argumente, um Plot abzuspeichern:
    %
    % save = Boolean (Default: false)
    % name = Dateiname (Default: yyyy-MM-dd_HH-mm-ss_plot)
    % path = Dateipfad (Default: \Plots)
    % format = Bildformat (Default: .png)
    % resolution = Grafikauflösung in DPI (Default: 300)
    
    %% Parameter
    global MotorParams
    % Static Gain
%     if ~exist('motorParams', 'var')
%         staticGain = 1.87*0.153*60/16/0.0255; % Default
%     else
        staticGain = MotorParams.staticGain;
%     end
    
    %% Daten 
    x1_p = squeeze(out.mX.Data(2, 1, :));
    phi1_p = squeeze(out.mX.Data(4, 1, :));
    phi2_p = squeeze(out.mX.Data(6, 1, :));
    Freal = squeeze(out.vF.Data);
    if out.vF.Time==out.mX.Time
        vT = out.mX.Time;
    else
       disp('out.mX.Time und out.vF.Time haben verschiedene Dimensionen.')
       return
    end   
    
    estExist = false;
    vorst = false;
    trajExist = false;
    try
        if ismember('vU', out.who)
            Ureal = squeeze(out.vU.Data);
        else
            Ureal = [];
        end
        
        if ismember('x_est', out.who) % Beobachterschätzwerte (nur bei Regelung)
            estExist = true;
            x1_p_est = squeeze(out.x_est.Data(1, 1, :));
            phi1_p_est = squeeze(out.x_est.Data(3, 1, :));
            phi2_P_est = squeeze(out.x_est.Data(5, 1, :));
        end

        if ismember('F_soll_reg', out.who) % Daten der Vorsteuerung (bei Regelung)
            vorst = true;
            Freg = squeeze(out.F_soll_reg.Data);
            Fsoll = squeeze(out.F_soll_real.Data);
            %Usoll = squeeze(out.Usoll.Data);
        end

        if ismember('mX_traj', out.who)
            trajExist = true;
            x1_p_traj = squeeze(out.mX_traj.Data(2, 1, :));
            phi1_p_traj = squeeze(out.mX_traj.Data(4, 1, :));
            phi2_p_traj = squeeze(out.mX_traj.Data(6, 1, :));
        end
    catch
        disp('Plots: Abfrage nach x_est, F_soll_reg und mX_traj wurde umgangen.')
    end
    
    %% Plot
    set(groot, 'DefaultTextInterpreter', 'tex')
    hFig = figure();
    
    subplot(4,1,1);       
	plot(vT, x1_p, 'Color', [0 0.4470 0.7410], 'LineWidth', 1);  
    hold on;
    title('Geschwindigkeit v');
	  ylabel('v [m/s]');
    if estExist
        plot(vT, x1_p_est, 'Color', [0.3010, 0.7450, 0.9330], 'LineWidth', 1);
        legend('v', 'v_{est}');
    end
    if trajExist
        plot(vT, x1_p_traj, 'Color', [0.3010, 0.7450, 0.9330], 'LineWidth', 1);
        legend('v', 'v_{traj}');
    end
    grid on;
    
    subplot(4,1,2);    
    plot(vT, rad2deg(phi1_p), 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1);
    hold on;	
    title('Winkelgeschwindigkeit \omega_{1}')
	  ylabel('\omega_{1} [°/s]');
    if estExist
        plot(vT, rad2deg(phi1_p_est), 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 1);
        legend('\omega_{1}', '\omega_{1-est}'); 
    end 
    if trajExist
        plot(vT, rad2deg(phi1_p_traj), 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 1);
        legend('\omega_{1}', '\omega_{1-traj}'); 
    end
    grid on;
    
    subplot(4,1,3);
    plot(vT, rad2deg(phi2_p), 'Color', [0.4940, 0.1840, 0.5560], 'LineWidth', 1);   
    hold on;	
    title('Winkelgeschwindigkeit \omega_{2}')
	  ylabel('\omega_{2} [°/s]');
    if estExist
        plot(vT, rad2deg(phi2_P_est), 'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 1);
        legend('\omega_{2}', '\omega_{2-est}'); 
    end    
    if trajExist
        plot(vT, rad2deg(phi2_p_traj), 'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 1);
        legend('\omega_{2}', '\omega_{2-traj}'); 
    end   
    grid on;
    
    subplot(4,1,4);
    hold on; 
    if vorst
        plot(vT, Freg, 'Color', [1, 0.5, 0.1], 'LineWidth', 1);
        plot(vT, Fsoll, 'Color', [0.8, 0.078, 0.184], 'LineWidth', 1);
        plot(vT, Freal, 'Color', [0.3, 0.5, 0.9], 'LineWidth', 1); 
        legend('F_{reg}', 'F_{soll}', 'F_{out}');
    elseif ~isempty(Ureal)        
        plot(vT, Ureal*staticGain, 'Color', [0.8, 0.078, 0.184], 'LineWidth', 1);
        plot(vT, Freal, 'Color', [0.3, 0.5, 0.9], 'LineWidth', 1); 
        legend('U_{in}*MotGain', 'F_{out}')
    else
        plot(vT, Freal, 'Color', [0.3, 0.5, 0.9], 'LineWidth', 1); 
    end
    title('Stellgröße (Kraft F)');
	ylabel('F [N]');
    grid on;

    xlabel('Zeit t [s]');
    
    
    %% Plot speichern
    if nargin==1
        return
    end
    % Default-Konfiguration
    currDate = datetime();
    currDate.Format = 'yyyy-MM-dd_HH-mm-ss';
    fileName = [char(currDate) '_' 'plot_velocities'];
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