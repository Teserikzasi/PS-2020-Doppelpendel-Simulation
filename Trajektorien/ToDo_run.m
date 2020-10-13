% ToDo-Liste für Matlab
%% Reibung
% N=500; T=0.005; simSol='RK4'; u_max = 410;
% paramsSource= 'app09';
% mode = 1;
% selectSuccess=true;
% coulMc = true; coulFc = true;
% nameExtension = '_Mc-rib20_Fc-app09';
% searchTrajectories(mode, N, T, simSol, paramsSource, u_max, coulMc, coulFc, selectSuccess, nameExtension)

%% Systemparameter
N = 500;
T = 0.005;
u_max = 410;
simSol='RK4';


poi = 's2';
val = 0:0.001:0.338; del = 0.1: 0.02 : 0.3;
poi_val = []; cnt = 1;
for i=1 : length(val)
    if ~ismember(val(i),del)
        poi_val(cnt)=val(i); cnt=cnt+1;
    end
end
params= SchlittenPendelParams_Apprich09();
examParameters(poi, poi_val, N, T, simSol, params, u_max)
poi = 's1';
val = 0:0.001:0.29; del = 0.06: 0.005 : 0.1;
poi_val = []; cnt = 1;
for i=1 : length(val)
    if ~ismember(val(i),del)
        poi_val(cnt)=val(i); cnt=cnt+1;
    end
end
params= SchlittenPendelParams_Apprich09();
examParameters(poi, poi_val, N, T, simSol, params, u_max)

% poi = ["m1", "m2", "J1", "J2", "s1", "s2"];
% rib20 = SchlittenPendelParams_Ribeiro20(); 
% for k=1 : length(poi)
%     poi_val = rib20.(poi(k));
%     params= SchlittenPendelParams_Apprich09();
%     examParameters(poi(k), poi_val, N, T, simSol, params, u_max)
% end

% %% Trajektoriensuche
% N=350; T=0.01; simSol='Euler'; u_max = 400;
% params= SchlittenPendelParams_Apprich09();
% mode = 2;
% selectSuccess=false;
% coulMc = false; coulFc = false;
% searchTrajectories_alt(mode, N, T, simSol, params, u_max, coulMc, coulFc, selectSuccess)



