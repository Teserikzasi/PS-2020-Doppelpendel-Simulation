% Run Section

%% Init
app09 = SchlittenPendelParams_Apprich09();
rib20 = SchlittenPendelParams_Ribeiro20();
baseTrjName = 'Traj14_dev0_-3.14_-3.14_x0max0.8';
searchPath = 'Trajektorien\ParameterExams_app09';
plotsPath = 'Trajektorien_Tests\Apprich09\RK4_MPC_T0.005N500\ParameterExam';

%% m1
poi = 'm1';
poi_val = 0:0.3:3;
poi_val = [poi_val(1:3), app09.(poi), rib20.(poi), poi_val(4:end)];

%% m2
poi = 'm2';
poi_val = 0:0.3:3;
poi_val = [poi_val(1:2), app09.(poi), rib20.(poi), poi_val(3:end)];

%% J1
poi = 'J1';
% poi_val = [0 0.002 0.004 0.006 0.0062 0.0064 0.00647 0.0066 0.0068 0.008 0.01 0.01128 0.012 0.014 0.016 0.018 0.02]; 
v1 = 0:0.002:0.02; v2 = 0.0062: 0.0002 : 0.0068; 
poi_val = [v1(1:4), v2, v1(5:end)];
poi_val = [poi_val(1:6), app09.(poi), poi_val(7:10), rib20.(poi), poi_val(11:end)];

%% J2
poi = 'J2';
poi_val = 0:0.002:0.02;
poi_val = [poi_val(1:2), rib20.(poi), poi_val(3), app09.(poi), poi_val(4:end)];

%% s1
poi = 's1';
poi_val = 0.06: 0.005 : 0.1;
poi_val = [poi_val(1:4), app09.(poi), poi_val(5:7), rib20.(poi), poi_val(8:end)];

%% s2
poi = 's2';
poi_val = 0.1: 0.03 : 0.34;
poi_val = [poi_val(1), rib20.(poi), poi_val(2) app09.(poi), poi_val(3:end)];

%% Plot
xScale = 'auto';
%plot_Jdev_params(poi, poi_val, baseTrjName, searchPath)
plot_Jdev_params(poi, poi_val, baseTrjName, searchPath, xScale, plotsPath)
%plot_traj_params(poi, poi_val, baseTrjName, searchPath, plotsPath)

%% Animationen
animate_trajs_params(poi, poi_val, baseTrjName, searchPath, fullfile(plotsPath, 'Trajektorien'));
