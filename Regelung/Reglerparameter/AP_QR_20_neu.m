function QRs = AP_QR_20_neu()
% Hier werden die Parameter des Riccati-Reglers aller Arbeitspunkte definiert
% Neudefinition PS2020 Gebhard/Tesar

QRs(1) = struct('R', 0.01, 'Q', diag([80, 1,  10, 1, 10, 1 ]) );
QRs(2) = struct('R', 0.01, 'Q', diag([10, 1,  1,  1, 10, 1 ]) );  % Pendel 2 instabil
QRs(3) = struct('R', 0.01, 'Q', diag([5,  80, 50, 1, 10, 1 ]) );  % Pendel 1 instabil
QRs(4) = struct('R', 0.01, 'Q', diag([1,  3,  1,  9, 1,  1 ]) );

QRs(1).name = '20_neu';

end