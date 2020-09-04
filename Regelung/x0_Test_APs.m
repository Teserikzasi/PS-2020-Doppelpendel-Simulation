
% Macht mehrere Anfangswert-Tests für AP 2,3,4

[max_y0_2, delta_max_2, guete_2] = x0_Test(2, 0, 0, deg2rad(1) ); % Pendel 2 instabil
[max_y0_3, delta_max_3, guete_3] = x0_Test(3, 0, deg2rad(1), 0 ); % Pendel 1 instabil
[max_y0_41, delta_max_41, guete_41] = x0_Test(4, 0, deg2rad(1), 0 );
[max_y0_42, delta_max_42, guete_42] = x0_Test(4, 0, 0,  deg2rad(1) );

fprintf('AP2 max phi20 = %.0f°\n', rad2deg(max_y0_2(3)) )
fprintf('AP3 max phi10 = %.0f°\n', rad2deg(max_y0_3(2)) )
fprintf('AP4 max phi10 = %.0f°\n', rad2deg(max_y0_41(2)) )
fprintf('AP4 max phi20 = %.0f°\n', rad2deg(max_y0_42(3)) )



%x0_Test( testAP, 0, deg2rad(0), deg2rad(5), true )

