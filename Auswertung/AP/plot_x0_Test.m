function plot_x0_Test(delta_max,guete,AP)

i=size(delta_max,1);

figure
plot(0:i-1,delta_max,'o--')
grid on
legend('x_{max}','\phi1_{max}','\phi2_{max}')
title(sprintf('Maximale Abweichung vom AP (%d)', AP))

figure
subplot(3,1,1)
plot(0:i-1,guete(:,1),'o--')
grid on
title('Jx')

subplot(3,1,2)
plot(0:i-1,guete(:,2),'o--')
grid on
title('Jxest')

subplot(3,1,3)
plot(0:i-1,guete(:,3),'o--')
grid on
title('Jf')

end