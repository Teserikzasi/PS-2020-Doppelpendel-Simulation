function [Axis] = PlotMPC(X_solution, MPC_Step, TimeFactor, Pendulum_Param, Axis)
%PLOTMPC Diese Funktion Plottet die Trajektorie eines MPC Durchgangs, nämlich Schritt MPC_Step. Dabei wird der Anfangs- und Endzustand des Pendels geplottet, sowie die Trajektorie des Endpunktes Stab 2 dazwischen 

l1 = Pendulum_Param.l1;
l2 = Pendulum_Param.l2;
MPC_Step_results = [X_solution(:,1,MPC_Step), X_solution(:,3,MPC_Step), X_solution(:,5,MPC_Step)];
Punkte_xy = [MPC_Step_results(:,1), zeros(size(MPC_Step_results,1),1), MPC_Step_results(:,1)+l1*sin(-MPC_Step_results(:,2)), l1*cos(MPC_Step_results(:,2)), MPC_Step_results(:,1)+l1*sin(-MPC_Step_results(:,2))+l2*sin(-MPC_Step_results(:,3)), l1*cos(MPC_Step_results(:,2))+l2*cos(MPC_Step_results(:,3))]; 

if isempty(Axis)
    x_max_pos = max([max(Punkte_xy(:,[1 3 5])),0.1]);
    x_min_pos = min([min(Punkte_xy(:,[1 3 5])),-0.1]);
    y_max_pos = max(max(Punkte_xy(:,[2 4 6])));
    y_min_pos = min(min(Punkte_xy(:,[2 4 6])));
    delta_x = abs(x_max_pos-x_min_pos);
    delta_y = abs(y_max_pos-y_min_pos);
    Axis = [x_min_pos-0.12*delta_x x_max_pos+0.12*delta_x y_min_pos-0.07*delta_y y_max_pos+0.2*delta_y];
else
    delta_x = Axis(2)- Axis(1);
    delta_y = Axis(4)- Axis(3);
end

% Title = ['Iterationsschritt ' num2str(MPC_Step) '/' num2str(size(X_solution,3)) ' der MPC-Berechnung', char(10)...
%     , 'Pr\"adiktionshorizont von ' num2str(length(MPC_Step_results)) ' Schritten'];

% title(Title,'Interpreter','latex');
axis(Axis);
%Zeichnet Schlitten in Anfangsposition
    hold on;
    rectangle('Position', [Punkte_xy(1,1)-0.12*delta_x, Punkte_xy(1,2)-0.07*delta_y, 0.24*delta_x, 0.14*delta_y],'EdgeColor', 'k');
    text(Punkte_xy(1,1)-0.1*delta_x, Punkte_xy(1,2)-0.05*delta_y,'$\,x_{init}$','FontSize', 15, 'VerticalAlignment', 'bottom','Interpreter','latex')
    rectangle('Position', [Punkte_xy(1,1)-0.01*delta_x, Punkte_xy(1,2)-0.01*delta_y, 0.02*delta_x, 0.02*delta_y],'EdgeColor', 'k','Curvature',[1,1],'FaceColor', 'k');
    rectangle('Position', [Punkte_xy(1,3)-0.01*delta_x, Punkte_xy(1,4)-0.01*delta_y, 0.02*delta_x, 0.02*delta_y],'EdgeColor', 'k','Curvature',[1,1],'FaceColor', 'k');
    line([Punkte_xy(1,1) Punkte_xy(1,3)], [Punkte_xy(1,2) Punkte_xy(1,4)], 'Color', 'k', 'LineWidth', 0.7);
    line([Punkte_xy(1,3) Punkte_xy(1,5)], [Punkte_xy(1,4) Punkte_xy(1,6)], 'Color', 'k', 'LineWidth', 0.7);

%Zeichnet Schlitten in Endposition
    hold on;
    rectangle('Position', [Punkte_xy(end,1)-0.12*delta_x, Punkte_xy(end,2)-0.07*delta_y, 0.24*delta_x, 0.14*delta_y], 'EdgeColor', 'k', 'FaceColor', [0.8 0.8 0.8]);
    text(Punkte_xy(end,1)-0.1*delta_x, Punkte_xy(end,2)-0.05*delta_y,'$\,x_{end}$','FontSize', 15, 'VerticalAlignment', 'bottom','Interpreter','latex')
    rectangle('Position', [Punkte_xy(end,1)-0.01*delta_x, Punkte_xy(end,2)-0.01*delta_y, 0.02*delta_x, 0.02*delta_y],'EdgeColor', 'k','Curvature',[1,1],'FaceColor', 'k');
    rectangle('Position', [Punkte_xy(end,3)-0.01*delta_x, Punkte_xy(end,4)-0.01*delta_y, 0.02*delta_x, 0.02*delta_y],'EdgeColor', 'k','Curvature',[1,1],'FaceColor', 'k');
    line([Punkte_xy(end,1) Punkte_xy(end,3)], [Punkte_xy(end,2) Punkte_xy(end,4)], 'Color', 'k', 'LineWidth', 0.7);
    line([Punkte_xy(end,3) Punkte_xy(end,5)], [Punkte_xy(end,4) Punkte_xy(end,6)], 'Color', 'k', 'LineWidth', 0.7);

%Zeichnet Trajektorie des Endpunktes von Stab 2
try
for k = 1:length(MPC_Step_results)-1
    line([Punkte_xy(k,5) Punkte_xy(k+1,5)], [Punkte_xy(k,6) Punkte_xy(k+1,6)],'Color' , [0.23, 0.78, 0.17], 'LineWidth', 1);
end 
end

%löscht die y-Achsenbeschriftung
set(gca,'FontSize',13.5)
set(0,'DefaultTextInterpreter', 'Latex');
xlabel('Position des Schlittens in m', 'fontsize', 15)
ax = gca;
set(ax,'YTickLabel',[]); 
ax.YTick = [];
ax.TickLabelInterpreter='latex';


%Bereich von Maxposition hinzufügen
plot(Punkte_xy(:,1),Punkte_xy(:,2), 'Color', 'r', 'LineWidth', 1);
ha1 = annotation('line', 'Color', 'r', 'LineWidth', 1);  % store the arrow information in ha
ha1.Parent = gca;    
ha1.X = [max(Punkte_xy(:,1)) max(Punkte_xy(:,1))];          % the location in data units
ha1.Y = [-0.05*delta_y 0.05*delta_y];
ha2 = annotation('line', 'Color', 'r', 'LineWidth', 1);  % store the arrow information in ha
ha2.Parent = gca;    
ha2.X = [min(Punkte_xy(:,1)) min(Punkte_xy(:,1))];          % the location in data units
ha2.Y = [-0.05*delta_y 0.05*delta_y];
text(min(Punkte_xy(:,1))-0.05*delta_x, 0.115*delta_y,sprintf('%0.3f',min(Punkte_xy(:,1))),'Color', 'r', 'FontSize', 13.5,'Interpreter','latex');
%text(min(Punkte_xy(:,1))-0.03, 0.07, num2str(min(Punkte_xy(:,1))),'Color', 'r');
text(max(Punkte_xy(:,1))-0.05*delta_x, 0.115*delta_y, sprintf('%0.3f',max(Punkte_xy(:,1))),'Color', 'r', 'FontSize', 13.5,'Interpreter','latex');

pause(TimeFactor);

end

