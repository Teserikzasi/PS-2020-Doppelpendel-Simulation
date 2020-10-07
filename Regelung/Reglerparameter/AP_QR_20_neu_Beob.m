function QRs = AP_QR_20_neu_Beob()
% Hier werden die Parameter des Riccati-Reglers aller Arbeitspunkte definiert
% Neudefinition PS2020 Gebhard/Tesar
% Für den Beobachter sind offenbar andere QR-Werte optimal

QRs(1) = struct('R', 0.01, 'Q', diag([80, 1,  10, 1, 10, 1 ]) );
QRs(2) = struct('R', 0.01, 'Q', diag([90, 1,  10, 4, 1,  1 ]) );  % Pendel 2 instabil
QRs(3) = struct('R', 0.01, 'Q', diag([90, 80, 10, 1, 10, 1 ]) );  % Pendel 1 instabil
QRs(4) = struct('R', 0.01, 'Q', diag([90, 20, 30, 9, 1,  5 ]) );

QRs(1).name = '20_neu_Beob';

end