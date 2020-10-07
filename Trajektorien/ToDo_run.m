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

poi = 'm2';
poi_val = 0.21:0.01:0.39;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 0.41:0.01:0.59;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 0.61:0.01:0.79;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 0.81:0.01:0.99;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 1.01:0.01:1.19;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 1.21:0.01:1.39;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 1.41:0.01:1.59;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 1.61:0.01:1.79;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 1.81:0.01:1.99;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)

poi = 'm1';
poi_val = 0.21:0.01:0.39;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 0.41:0.01:0.49;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 0.91:0.01:0.99;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 1.01:0.01:1.19;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 1.21:0.01:1.39;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 1.41:0.01:1.59;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 1.61:0.01:1.79;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
poi_val = 1.81:0.01:1.99;
examParameters(poi, poi_val, N, T, simSol, paramsSource, u_max)
% poi = ["m1", "m2", "J1", "J2", "s1", "s2"];
% rib20 = SchlittenPendelParams_Ribeiro20(); 
% for k=1 : length(poi)
%     poi_val = rib20.(poi(k));
%     examParameters(poi(k), poi_val, N, T, simSol, paramsSource, u_max)
% end

%% Trajektoriensuche
N=350; T=0.01; simSol='Euler'; u_max = 400;
paramsSource= 'app09';
mode = 2;
selectSuccess=false;
coulMc = false; coulFc = false;
searchTrajectories_alt(N, T, simSol, paramsSource, u_max, mode, coulMc, coulFc, selectSuccess)



