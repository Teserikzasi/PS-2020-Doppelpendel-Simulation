function selectTrajectories(condition, saving, dev_x0, searchPath, destPath)
% Macht eine Auswahl der gefundenen Trajektorien
% Kriterium: Normierter Gesamtfehler im Zielzustand
if ~exist('save', 'var')
    saving = true;
end
if ~exist('searchPath', 'var')
    resFolderName = 'Results_odeFauve_maxIt10000'; % Wähle Ordner mit Ergebnissen der Trajektoriensuche
    subfolderPath = 'Trajektorien\searchResults';
    searchPath = fullfile(subfolderPath, resFolderName);
end

if ~exist('destPath', 'var') % Zielpfad
    destPath = fullfile(searchPath, 'Selection');
end
if ~exist(destPath, 'dir')
    mkdir(destPath);
end

% Rekonstruktion des Dateinamens (definiert in trajectorySearch)
if ~exist('dev_x0', 'var')
    dev_x0 = [0.5 0.3 0.1 0];
end
dev_AP_phi1 = [pi -pi  pi -pi -pi pi 0   0];   
dev_AP_phi2 = [pi  pi -pi -pi  0  0 -pi  pi]; 
for k_ubx0=1 : 5   % Variation der Positionsbeschränkung
    x0_max = 0.4+0.2*k_ubx0;      
    for k_pos=1 : length(dev_x0)  % Variation der Position
        for AP_end=1 : 4    % Variation des Ziel-Arbeitspunkts
            for k_dev_phi=1 : length(dev_AP_phi1)   % Variation der Pendelausgangslage
                devInitPhi1 = dev_AP_phi1(k_dev_phi);
                devInitPhi2 = dev_AP_phi2(k_dev_phi);
                
                % ermittle AP der Ausgangslage
                switch AP_end
                    case 1
                        if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                            AP_init = 4;
                        elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                            AP_init = 2;
                        else
                            AP_init = 3;
                        end
                    case 2
                        if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                            AP_init = 3;
                        elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                            AP_init = 4;
                        else
                            AP_init = 1;
                        end
                    case 3
                        if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                            AP_init = 2;
                        elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                            AP_init = 1;
                        else
                            AP_init = 4;
                        end                               
                    case 4
                        if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
                            AP_init = 1;
                        elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
                            AP_init = 2;
                        else
                            AP_init = 3;
                        end
                end
                
                
                fileName = ['Traj' num2str(AP_init) num2str(AP_end)  ...
                        '_dev' num2str(dev_x0(k_pos)) '_' sprintf('%0.2f',devInitPhi1) '_' ...
                      sprintf('%0.2f',devInitPhi2) '_x0max'  num2str(x0_max) '.mat'];
                  
               try
                   data = load(fullfile(searchPath, fileName));
                   dev = data.results_traj.dev;

                   if ~exist('condition', 'var')
                       condition = 0.01;
                   end
                   
                   % Wenn Genauigkeitsbedingung erfüllt, dann speichern im
                   % Zielordner
                   if dev <= condition                       
                       filePath = fullfile(destPath, fileName);
                       fprintf('%s\n', fileName);
                       if saving
                           save(filePath, '-struct', 'data');   
                       end
                   end
               catch
                   fprintf('%s existiert nicht in %s \n', fileName, searchPath); 
               end
                   
                               
            end
        end
    end
end




end

