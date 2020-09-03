function [] = PlotTraj_ij(parent, ubx1, X_prediction, Pendulum_Param, u_prediction, T, x_init, x_end, u_prediction_noise)
%Diese Funktion plotet den Plot (PlotMPC) sowie (PlotU) und (PlotInitEnd)
%für eine übergebene MPC berechnung
if (nargin < 9), u_prediction_noise = []; end % Standardwert für u_prediction_noise ist []


panel1 = uipanel('Parent',parent,'Position', [0, 0, 0.25, 1],'HighLightColor','w','BackgroundColor','w');
subplot(1,1,1, 'Parent', panel1,'Color','w');
hold;
PlotMPC(X_prediction, 1, 0, Pendulum_Param, []);
text(1,1,['$ ubx_1'  '=' num2str(ubx1) '$'], 'Units', 'normalized', 'Interpreter', 'latex','HorizontalAlignment' ,'right','FontSize', 15)

panel2 = uipanel('Parent',parent,'Position', [0.25, 0, 0.45, 1],'HighLightColor','w','BackgroundColor','w');
subplot(1,1,1, 'Parent', panel2,'Color','w');
PlotU(u_prediction, 1 , T, u_prediction_noise);

panel3 = uipanel('Parent',parent,'Position', [0.7, 0, 0.3, 1],'HighLightColor','w','BackgroundColor','w');
subplot(1,1,1, 'Parent', panel3,'Color','w');
PlotInitEnd(Pendulum_Param, x_init, x_end);

end

