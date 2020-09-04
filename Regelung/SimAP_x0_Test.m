function [max_y0, delta_max, guete] = SimAP_x0_Test(AP, x_st, phi1_st, phi2_st, plotall)
% Simuliert nacheinander immer höhere Anfangswerte bis zur Instabilität

if ~exist('plot', 'var')
    plotall=false;
end

fprintf('\nSim AP %d Anfangswert-Test...\n', AP )
fprintf('Step delta x0:  x = %.2f  phi1 = %.0f°  phi2 = %.0f°\n', ...
    x_st, rad2deg(phi1_st), rad2deg(phi2_st) )

i=0;
while (i==0 || results.stabilised)
    dx0    = i*x_st;
    dphi10 = i*phi1_st;
    dphi20 = i*phi2_st;
    [simout, results] = SimAP(AP, [dx0 0 dphi10 0 dphi20 0] );
    if results.stabilised
        delta_max(i+1,:) = [results.x(1).max, results.x(3).max, results.x(5).max];
        guete(i+1,:) = [results.Jx, results.Jxest, results.Jf];
    end
    if plotall
        plot_outputs(simout)
    end
    i=i+1;
end

max_x0    = (i-2)*x_st;
max_phi10 = (i-2)*phi1_st;
max_phi20 = (i-2)*phi2_st;
max_y0 = [max_x0, max_phi10, max_phi20];

figure
plot(0:i-2,delta_max,'o--')
grid on
legend('x_{max}','\phi1_{max}','\phi2_{max}')
title('Maximale Abweichung vom AP')

figure
subplot(3,1,1)
plot(0:i-2,guete(:,1),'o--')
grid on
title('Jx')

subplot(3,1,2)
plot(0:i-2,guete(:,2),'o--')
grid on
title('Jxest')

subplot(3,1,3)
plot(0:i-2,guete(:,3),'o--')
grid on
title('Jf')

end