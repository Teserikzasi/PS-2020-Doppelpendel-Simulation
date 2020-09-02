function [] = PlotInitEnd( Pendulum_Param, x_init, x_end)
%Diese Funktion plottet den Anfangs- (x_init) und den Endzustand (x_end)
%einer MPC

l1 = Pendulum_Param.l1;
l2 = Pendulum_Param.l2;

X = [transpose(x_init); transpose(x_end)]
MPC_Step_results = [X(:,1), X(:,3), X(:,5)];
Punkte_xy = [MPC_Step_results(:,1), zeros(size(MPC_Step_results,1),1), MPC_Step_results(:,1)+l1*sin(-MPC_Step_results(:,2)), l1*cos(MPC_Step_results(:,2)), MPC_Step_results(:,1)+l1*sin(-MPC_Step_results(:,2))+l2*sin(-MPC_Step_results(:,3)), l1*cos(MPC_Step_results(:,2))+l2*cos(MPC_Step_results(:,3))]; 

x_max_pos = max(max(Punkte_xy(:,[1 3 5])))+0.1;
x_min_pos = min(min(Punkte_xy(:,[1 3 5])))-0.1;
y_max_pos = max(max(Punkte_xy(:,[2 4 6])))+0.1;
y_min_pos = min(min(Punkte_xy(:,[2 4 6])))-0.1;
Axis = [x_min_pos x_max_pos y_min_pos y_max_pos]


subplot(1,2,1)
axis(Axis);
ax = gca;
set(ax,'YTickLabel',[]); 
ax.YTick = [];
ax.TickLabelInterpreter='latex';
%Zeichnet Schlitten in Anfangsposition
    hold;
    rectangle('Position', [Punkte_xy(1,1)-0.1, Punkte_xy(1,2)-0.05, 0.2, 0.1],'EdgeColor', 'k');
    text(Punkte_xy(1,1)-0.1, Punkte_xy(1,2)-0.05,'$\,x_{init}$','FontSize',14, 'VerticalAlignment', 'bottom','Interpreter','latex')
    
    plot(Punkte_xy(1,3), Punkte_xy(1,4), 'k.', 'MarkerSize', 25);
    
    line([Punkte_xy(1,1) Punkte_xy(1,3)], [Punkte_xy(1,2) Punkte_xy(1,4)], 'Color', 'k', 'LineWidth', 3);
    line([Punkte_xy(1,3) Punkte_xy(1,5)], [Punkte_xy(1,4) Punkte_xy(1,6)], 'Color', 'k', 'LineWidth', 3);

init1 = mat2str(x_init(1),5);
init2 = mat2str(x_init(2),5);
init3 = mat2str(rad2deg(x_init(3)),5);
init4 = mat2str(rad2deg(x_init(4)),5);
init5 = mat2str(rad2deg(x_init(5)),5);
init6 = mat2str(rad2deg(x_init(6)),5);

Text1 = ['x_{init}' newline,...
    '-------', newline,...
    init1, newline,...
    init2, newline,...
    init3, newline,...
    init4, newline,...
    init5, newline,...
    init6];

text(ax.XLim(2), ax.YLim(2), Text1,'FontSize',12, 'VerticalAlignment', 'top');

    
subplot(1,2,2)
axis(Axis);
%Zeichnet Schlitten in Endposition
    hold;
    rectangle('Position', [Punkte_xy(end,1)-0.1, Punkte_xy(end,2)-0.05, 0.2, 0.1], 'EdgeColor', 'k', 'FaceColor', [0.8 0.8 0.8]);
    text(Punkte_xy(end,1)-0.1, Punkte_xy(end,2)-0.05,'$\,x_{end}$','FontSize',14, 'VerticalAlignment', 'bottom','Interpreter','latex')
    
    plot(Punkte_xy(end,3), Punkte_xy(end,4), 'k.', 'MarkerSize', 25);
    
    line([Punkte_xy(end,1) Punkte_xy(end,3)], [Punkte_xy(end,2) Punkte_xy(end,4)], 'Color', 'k', 'LineWidth', 3);
    line([Punkte_xy(end,3) Punkte_xy(end,5)], [Punkte_xy(end,4) Punkte_xy(end,6)], 'Color', 'k', 'LineWidth', 3);

ax = gca;
set(ax,'YTickLabel',[]); 
ax.YTick = [];
ax.TickLabelInterpreter='latex';

end1 = mat2str(x_end(1),5);
end2 = mat2str(x_end(2),5);
end3 = mat2str(rad2deg(x_end(3)),5);
end4 = mat2str(rad2deg(x_end(4)),5);
end5 = mat2str(rad2deg(x_end(5)),5);
end6 = mat2str(rad2deg(x_end(6)),5);

Text2 = ['x_{end}' newline,...
    '-------', newline,...
    end1, newline,...
    end2, newline,...
    end3, newline,...
    end4, newline,...
    end5, newline,...
    end6];

text(ax.XLim(2), ax.YLim(2), Text2,'FontSize',12, 'VerticalAlignment', 'top');


end

