function QRs = AP_QR_Chang19()
% Hier werden die Parameter des Riccati-Reglers aller Arbeitspunkte definiert
% nach Chang19

QRs(1) = struct('R', 0.001, 'Q', diag([100, 1,   10,  1,      10,  1    ]) );
QRs(2) = struct('R', 0.1,   'Q', diag([100, 1,   20,  0.0001, 20,  0.01 ]) );
QRs(3) = struct('R', 0.01,  'Q', diag([360, 7.2, 2.1, 0.1,    1.6, 0.3  ]) );
QRs(4) = struct('R', 0.07,  'Q', diag([3,   9.3, 1.5, 3.9,    0.1, 2.6  ]) );

end