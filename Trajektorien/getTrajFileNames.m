function [nameList, x_init_List, AP_init_List, AP_end_List] = getTrajFileNames()
%Gibt Liste aller Namenskombinationen für Trajektorien zurück

global Ruhelagen
nameList = {};
x_init_List = zeros(6, 640);
AP_init_List = zeros(640, 1);
AP_end_List = zeros(640, 1);
i = 1;
% Rekonstruktion des Dateinamens (definiert in trajectorySearch)
[dev_x0, dev_AP_phi1, dev_AP_phi2] = getInitDev();
for k_ubx0=1 : 5   % Variation der Positionsbeschränkung
    x0_max = 0.4+0.2*k_ubx0;      
    for k_pos=1 : length(dev_x0)  % Variation der Position
        for AP_end=1 : 4    % Variation des Ziel-Arbeitspunkts
            for k_dev_phi=1 : length(dev_AP_phi1)   % Variation der Pendelausgangslage
                devInitPhi1 = dev_AP_phi1(k_dev_phi);
                devInitPhi2 = dev_AP_phi2(k_dev_phi);

                % ermittle AP der Ausgangslage               
                AP_init = determineAPinit(AP_end, devInitPhi1, devInitPhi2);              
                
                fileName = ['Traj' num2str(AP_init) num2str(AP_end)  ...
                        '_dev' num2str(dev_x0(k_pos)) '_' sprintf('%0.2f',devInitPhi1) '_' ...
                      sprintf('%0.2f',devInitPhi2) '_x0max'  num2str(x0_max) '.mat'];
                nameList{i} = fileName;
                
                x_init_List(:, i) = Ruhelagen(AP_end).x + [-dev_x0(k_pos) 0 devInitPhi1 0 devInitPhi2 0]';
                AP_init_List(i) = AP_init;
                AP_end_List(i) = AP_end;
                
                i = i + 1;
            end                                                  
        end
    end
end
end


