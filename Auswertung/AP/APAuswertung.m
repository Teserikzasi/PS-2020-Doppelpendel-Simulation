function results = APAuswertung(out)
% Wertet die Simulation von AP Regelung Test aus

Tsim = out.tout(end)-out.tout(1);
F = squeeze(out.vF.Data);
u = squeeze(out.delta_u.Data);
dt = Tsim/length(u); % Konstante Schrittweite angenommen

x = squeeze(out.delta_x_real.Data);
xest = squeeze(out.delta_x_est.Data);
xesterr = x - xest;
results.xend = x(:,end);

Q = diag([50, 1, 50, 1, 50, 1 ]);
R = 1;

results.Jf = F'*R*F * dt;  % Gütefunktional zur Stellgröße (real)
results.Ju = u'*R*u * dt;
results.Jx = sum(diag(Q*x*x')) * dt; % Gütefunktional zum Zustandsverlauf
results.Jxest = sum(diag(Q*xesterr*xesterr')) * dt; % Gütefunktional zum Zustandsfehler
results.xnorm = sum(Q*x.^2,1); % Verlauf der "norm"
results.xend_norm = results.xend'*Q*results.xend;

maxnormstab = 20;
if results.xend_norm < maxnormstab && ~any(out.outofcontrol.Data)
    results.stabilised = true;
else
    results.stabilised = false;
end

maxnormin = 0.1;
results.xnorm_ausw = AuswertungSignal(results.xnorm, maxnormin);
results.xnorm_ausw.tein = out.delta_x_real.Time(results.xnorm_ausw.in);

in = [0.01, 0.1, deg2rad(3), 0.1, deg2rad(3), 0.1 ];
for i=1:6
    results.x(i) = AuswertungSignal(x(i,:), in(i) );
    %results.x(i).tein = out.delta_x_real.Time(results.x(i).in);  %Subscripted assignment between dissimilar structures. ???
end

end