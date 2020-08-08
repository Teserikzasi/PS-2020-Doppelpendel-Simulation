function results = APAuswertung(out)
% Wertet die Simulation von AP Regelung Test aus

Tsim = out.tout(end)-out.tout(1);
u = squeeze(out.delta_u.Data);
x = squeeze(out.delta_x.Data);
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

Q = eye(6);
R = 1;

results.Ju = u'*R*u * dt;
results.Jx = sum(diag(x'*Q*x)) * dt;
results.Jxest = sum(diag(xesterr'*Q*xesterr)) * dt;

end