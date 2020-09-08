function QRs = AP_QR_Ribeiro20()
% Hier werden die Parameter des Riccati-Reglers aller Arbeitspunkte definiert
% nach Ribeiro20

QRs(1) = struct('R', 0.01, 'Q', diag([10,  1, 10,  1, 10,  1 ]) );
QRs(2) = struct('R', 0.01, 'Q', diag([100, 1, 1,   1, 10,  1 ]) );
QRs(3) = struct('R', 0.01, 'Q', diag([100, 1, 10,  1, 1,   1 ]) );
QRs(4) = struct('R', 0.01, 'Q', diag([10,  1, 100, 1, 100, 1 ]) );

end