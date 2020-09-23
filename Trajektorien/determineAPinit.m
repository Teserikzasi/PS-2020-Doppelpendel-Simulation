function [AP_init] = determineAPinit(AP_end, devInitPhi1, devInitPhi2)
% Ermittelt AP_init einer Trajektorie basierend auf der Anfangsauslenkung
% bezüglich AB_end
switch AP_end
    case 1
        if abs(devInitPhi1)==pi && abs(devInitPhi2)==pi
            AP_init = 4;
        elseif abs(devInitPhi1)==pi && abs(devInitPhi2)==0
            AP_init = 3;
        else
            AP_init = 2;
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
    otherwise
        AP_init = 0;
        disp('AP_init konnte nicht bestimmt werden.')
end
end

