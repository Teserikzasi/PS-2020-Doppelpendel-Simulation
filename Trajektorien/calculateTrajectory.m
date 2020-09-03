function [results] = calculateTrajectory(conficMPC)
% Berechnet eine Trajektorie mit Multiple Shooting für das
% Kraftmodell
% Input:    conficMPC (struct)
% Fields: 
%     N Zeithorizont
%     T Schrittweite
%     Q Zustands-Gewichtungsmatrix der Kostenfunktion 
%     R Stellgrößen-Gewichtungsmatrix der Kostenfunktion 
%     x_init Initialzustand
%     x_end Zielzustand
%     x0_max Positionsbegrenzung
%     u_max Stellgrößenbegrenzung
% Optional:
%     opts Optionen für nlpsol [Default: leer]
%     u0init Schätzung für Eingangs-Startwerte [Default: zeros(1, N)]
%     X0init Schätzung für Zustands-Startwerte [Default: S-Verlauf]
%     condition Zulässigkeitsbedingung [Default: 1e-2]
import casadi.*
clear g

%% MPC Konfiguration
N = conficMPC.N;
T = conficMPC.T;
Q = conficMPC.Q;
R = conficMPC.R;
x_init = conficMPC.x_init;
x_end = conficMPC.x_end;
Fmax = conficMPC.u_max;
x0max = conficMPC.x0_max;


%% Optimal Control Problem

% Zustandsgleichungen (Kraftmodell)
coulomb = false;
%[ode, x, u] = getODE(coulomb);
[ode, x, u] = getODE_Fauve();
xLength = length(x);

% Symbolische Ausdrücke für gesamten Zeithorizont
f = Function('f', {x, u}, {ode});
U = SX.sym('U', 1, N);
X = SX.sym('X', xLength, N+1);
P = SX.sym('P', xLength + xLength);
g = SX.zeros(xLength*(N+1), 1);

% Anfangsbedingung
g(1:xLength) = X(:,1) - P(1:xLength);

% Zielfunktion und Kontinuitätsbedingung (Integrator: Euler)
J = 0;
for k=1 : N
    x_k = X(:,k); 
    u_k = U(:,k);
    % Zielfunktion
    J = J + transpose(x_k - P(xLength+1:2*xLength))*Q*(x_k - P(xLength+1:2*xLength)) + u_k*R*u_k;
    
    % Kontinuitätsbedingung Multiple Shooting
    x_next = X(:,k+1);   
    x_next_euler = x_k + T * f(x_k,u_k); %Euler   
    g(k*xLength+1 : k*xLength+xLength) = x_next - x_next_euler; 
end 

% Nebenbedingungen
args = struct;
args.lbg(1:xLength*(N+1)) = 0;  % initialisiere g-Grenzen
args.ubg(1:xLength*(N+1)) = 0;
args.lbx(1 : xLength : xLength*(N+1), 1) = -x0max;  % x0 Begrenzung
args.ubx(1 : xLength : xLength*(N+1), 1) = x0max;
for i=2 : xLength % restliche Zustände ohne Begrenzung
    args.lbx(i : xLength: xLength*(N+1), 1) = -inf;
    args.ubx(i : xLength: xLength*(N+1), 1) = inf;
end
args.lbx(xLength*(N+1)+1 : xLength*(N+1)+N,1) = -Fmax; % Stellgrößenbeschränkung
args.ubx(xLength*(N+1)+1 : xLength*(N+1)+N,1) = Fmax;


%% Schätzung für Startwerte
% Stellgröße
if isfield(conficMPC, 'u0init') && ~isempty(conficMPC.u0init)
    u0init = conficMPC.u0init;
else
    u0init = zeros(1, N);
end
% Zustände
if isfield(conficMPC, 'X0init') && ~isempty(conficMPC.X0init)
    X0init = conficMPC.X0init;
else
    % S-förmige Interpolation
    t_ref = [0 N/4 3*N/4 N];
    x0_ref = [x_init(1) x_init(1) x_end(1) x_end(1)];
    phi1_ref = [x_init(3) x_init(3) x_end(3) x_end(3)];
    phi2_ref = [x_init(5) x_init(5) x_end(5) x_end(5)];

    t_inter= 0:1:N;
    x0_inter = pchip(t_ref,x0_ref,t_inter);
    phi1_inter = pchip(t_ref,phi1_ref,t_inter);
    phi2_inter = pchip(t_ref,phi2_ref,t_inter);

    X0init = [x0_inter; zeros(1, N+1); phi1_inter; zeros(1, N+1); phi2_inter; zeros(1, N+1)];
    %plot(t_inter, x0_inter, t_inter, phi1_inter, t_inter, phi2_inter);
end


%% NLP Solver
opts = struct;
if isfield(conficMPC, 'opts') && isstruct(conficMPC.opts)
    opts = conficMPC.opts;
end
w = [reshape(X, xLength*(N+1), 1); transpose(U)]; % Optimierungsparameter (X+U für multiple Shooting)
nlp = struct('f', J, 'x', w, 'g', g, 'p', P);
solver = nlpsol('solver', 'ipopt', nlp, opts);


%% Lösung des NLP (= eine MPC-Prädiktion über N)
% Startwerte
sol.p = [x_init; x_end];
sol.w0 = [reshape(transpose(X0init), xLength*(N+1), 1); transpose(u0init)];

% Trajektorie
results = struct;
solution = solver('x0', sol.w0, 'p', sol.p, 'lbx', args.lbx, 'ubx', args.ubx, 'lbg', args.lbg, 'ubg',args.ubg);
results.u_traj = full( solution.x(xLength*(N+1)+1 : end) );
results.x_traj = reshape( full( solution.x(1 : xLength*(N+1)))', xLength, N+1);
results.g_traj = full(solution.g);


% Zulässigkeitsprüfung
if isfield(conficMPC, 'condition') && ~isempty(conficMPC.condition)
    condition = conficMPC.condition;    
else
    condition = 1e-2;
end
x_end_mpc = results.x_traj(:,end);
dev = norm(x_end-x_end_mpc, 2);
if  dev < condition 
    results.condition = 1;
    fprintf('Trajektorie gefunden für xinit = [%0.2f %0.2f %0.2f %0.2f %0.2f %0.2f] und xend = [%0.2f %0.2f %0.2f %0.2f %0.2f %0.2f]\n', x_init, x_end)
else
    results.condition = 0;
end
    
end
