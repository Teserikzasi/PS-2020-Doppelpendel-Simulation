
%% Init
app09 = SchlittenPendelParams_Apprich09();
rib20 = SchlittenPendelParams_Ribeiro20();
baseTrjName = 'Traj14_dev0_-3.14_-3.14_x0max0.8_Fmax410';
searchPath = 'Trajektorien\ParameterExams_app09';
plotsPath = 'Trajektorien_Tests\Apprich09\RK4_MPC_T0.005N500\ParameterExam';

poi = ["m1", "m2", "J1", "J2", "s1", "s2"]; % Parameters of Interest
i=1;
poi_val = cell(length(poi),1);
%% m1
v1 = 0:0.2:2; v2 = 0.5:0.01:0.9;
poi_val{i} = [v1(1:3), v2, v1(6:end)];
i=i+1;
%% m2
v1 = 0:0.2:2; v2 = 0.2:0.01:1.25;
poi_val{i} = [v1(1), v2, v1(7:end)];
i=i+1;
%% J1
% poi_val = [0 0.002 0.004 0.006 0.0062 0.0064 0.00647 0.0066 0.0068 0.008 0.01 0.01128 0.012 0.014 0.016 0.018 0.02]; 
% v1 = 0:0.002:0.02; v2 = 0.0062: 0.0002 : 0.0068; 
% poi_val = [v1(1:4), v2, v1(5:end)];
poi_val{i} = 0:0.002:0.02;
i=i+1;
%% J2
poi_val{i} = 0:0.002:0.02;
i=i+1;
%% s1
poi_val{i} = 0.06: 0.005 : 0.1;
i=i+1;
%% s2
poi_val{i} = 0.1: 0.02 : 0.3;
%% Plot
xScale = 'auto';
for k=1 : length(poi)
%     plot_Jdev_params(poi{k}, poi_val{k}, baseTrjName, searchPath)
    plot_Jdev_params(poi{k}, poi_val{k}, baseTrjName, searchPath, xScale, plotsPath)
    %plot_traj_params(poi{k}, poi_val{k}, baseTrjName, searchPath, plotsPath)
end

%% Animationen
%animate_trajs_params(poi, poi_val, baseTrjName, searchPath, fullfile(plotsPath, 'Trajektorien'));
