%% Demo-Aufruf von searchTrajectories
mode = 2;           % Suchprogramm
N = 500;            % Zeithorizont
T = 0.005;          % Schrittweite
sol = 'RK4';        % Integrator für Kontinuitätsbedingung
params= SchlittenPendelParams_Apprich09(); % Parametersatz
u_max = 410;        % Maximale Stellkraft
coulMc = false;     % Gelenkreibung nicht berücksichtigen
coulFc = true;      % Schlittenreibung berücksichtigen

% Starte Suche nach Trajektorien
searchTrajectories(mode, N, T, sol, params, u_max, ...
                    coulMc, coulFc)
