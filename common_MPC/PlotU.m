function [] = PlotU(u_solution, MPC_Step, T, u_prediction_noise)
%gibt den Stellgrößenverlauf aus
if (nargin < 4), u_prediction_noise = []; end % Standardwert für u_prediction_noise ist []


t_uk = (MPC_Step-1)*T:T:T*(size(u_solution,1)-1)+(MPC_Step-1)*T;
p1 = stairs(transpose(t_uk),u_solution(:,1,MPC_Step),'Color' , [0, 0.49, 0.96], 'LineWidth', 1);
hold;
if ~isempty(u_prediction_noise)
    a = reshape(u_prediction_noise(1,1,:),[],1);
    stairs(t_uk,a,'Color', 'r', 'LineWidth', 0.8);
end


[lgd, objH] = legend(p1, '$$u(t)$$');
hl = findobj(objH,'type','line');
set(hl,'LineWidth',1.5);
set(objH(1), 'FontSize', 15,'Interpreter','latex');
set(gca,'FontSize',13.5);
ax1=gca;
ax1.TickLabelInterpreter='latex';
xlabel('$t$ in s', 'fontsize', 15,'Interpreter','latex')
ylabel('Stellgr{\"o}{\ss}e $u(t)$ in N', 'fontsize', 15,'Interpreter','latex')
mi = min(u_solution(:,1,MPC_Step));
ma = max(u_solution(:,1,MPC_Step));
ax1.YLim = [mi-0.05*(ma-mi) ma+0.05*(ma-mi)];
ax1.XLim = [t_uk(1) t_uk(end)];
end

