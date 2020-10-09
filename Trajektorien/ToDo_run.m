% ToDo-Liste für Matlab
%% Reibung
% N=500; T=0.005; simSol='RK4'; u_max = 410;
% paramsSource= 'app09';
% mode = 1;
% selectSuccess=true;
% coulMc = true; coulFc = true;
% nameExtension = '_Mc-rib20_Fc-app09';
% searchTrajectories(N, T, simSol, paramsSource, u_max, mode, coulMc, coulFc, selectSuccess, nameExtension)

%% Systemparameter
N = 500;
T = 0.005;
u_max = 410;
simSol='RK4';
paramsSource= 'app09';

poi = 'J2';
val = 0:0.0001:0.02; del = 0:0.002:0.02;
poi_val = []; cnt = 1;
for i=1 : length(val)
    if ~ismember(val(i),del)
        poi_val(cnt)=val(i); cnt=cnt+1;
    end
end
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi = 'J1';
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)

% poi = ["m1", "m2", "J1", "J2", "s1", "s2"];
% rib20 = SchlittenPendelParams_Ribeiro20(); 
% for k=1 : length(poi)
%     poi_val = rib20.(poi(k));
%     examParameters(poi(k), poi_val, N, T, simSol, paramsSource, u_max)
% end

% %% Trajektoriensuche
% N=350; T=0.01; simSol='Euler'; u_max = 400;
% paramsSource= 'app09';
% mode = 2;
% selectSuccess=false;
% coulMc = false; coulFc = false;
% searchTrajectories_alt(N, T, simSol, paramsSource, u_max, mode, coulMc, coulFc, selectSuccess)



