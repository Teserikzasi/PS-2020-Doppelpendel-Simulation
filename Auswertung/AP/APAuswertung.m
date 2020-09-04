function results = APAuswertung(out)
% Wertet die Simulation von AP Regelung Test aus

Tsim = out.tout(end)-out.tout(1);
F = squeeze(out.vF.Data);
u = squeeze(out.delta_u.Data);
x = squeeze(out.delta_x_real.Data);
xest = squeeze(out.delta_x_est.Data);
xesterr = x - xest;
dt = Tsim/length(u); % Konstante Schrittweite angenommen

results.xend = x(:,end);
results.xend_norm = norm(results.xend);

maxnorm = 0.1;
if results.xend_norm < maxnorm
    results.stabilised = true;
else
    results.stabilised = false;
end

Q = diag([10, 1, 10, 1, 10, 1 ]);
R = 1;

results.Jf = F'*R*F * dt;  % Gütefunktional zur Stellgröße
results.Ju = u'*R*u * dt;
results.Jx = sum(diag(Q*x*x')) * dt; % Gütefunktional zum Zustandsverlauf
results.Jxest = sum(diag(Q*xesterr*xesterr')) * dt; % Gütefunktional zum Zustandsfehler

in = [0.05, 0.1, 0.05, 0.1, 0.05, 0.1 ];
for i=1:6
    results.x(i) = AuswertungSignal(x(i,:), in(i) );
    %results.x(i).tein = out.delta_x_real.Time(results.x(i).in);  %Subscripted assignment between dissimilar structures. ???
end

end