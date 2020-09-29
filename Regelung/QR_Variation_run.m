
res2R = QR_Variation(2, AP_QR_20_neu(), 'R', logspace(-3,1,10) )
res2R = QR_Variation(2, AP_QR_20_neu(), 'R', logspace(-3,1,10), 3, [0,0,deg2rad(1)] ) % Pendel2
res2Q = QR_Variation(2, AP_QR_20_neu(), 'Q1', logspace(-2,2,7), 1:3 )
res2Q = QR_Variation(2, AP_QR_20_neu(), 'Q5', logspace(-2,2,7), 3 ) % Pendel2
res2Q = QR_Variation(2, AP_QR_20_neu(), 'Q6', logspace(-2,2,7), 2:3 )

res3R = QR_Variation(3, AP_QR_20_neu(), 'R', logspace(-3,1,10) )
res3Q = QR_Variation(3, AP_QR_20_neu(), 'Q1', logspace(-1,3,7) )
res3Q = QR_Variation(3, AP_QR_20_neu(), 'Q3', logspace(0,3,7), 2 ) % Pendel 1

res4R = QR_Variation(4, AP_QR_20_neu(), 'R', logspace(-3,1,10) )
res4Q = QR_Variation(4, AP_QR_20_neu(), 'Q1', logspace(-2,2,7) )
res4Q = QR_Variation(4, AP_QR_20_neu(), 'Q3', logspace(-1,2,7), 2:3 )
res4Q = QR_Variation(4, AP_QR_20_neu(), 'Q5', logspace(-1,2,7), 2:3 )
