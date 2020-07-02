function [stTraj, sol] = getFeedForward_QR(stSys, T, x0, xT, Q, R, stInit)

    stTrajInit = [];
    stSolinit = [];
    vTinit = [];
    
    if (nargin < 7)
        vTinit = linspace(0, T, 1001);
    else
        if isnumeric(stInit)
            if (length(stInit) == 1)
                vTinit = linspace(0, T, stInit);
            else
                vTinit = stInit;
            end
        elseif isfield(stInit, 'T')
            stTrajInit = stInit;
        elseif ( isfield(stInit, 'x') && isfield(stInit, 'y') )
            stSolinit = stInit;
        else
            error('Fehler: Ungültiger Wert für stInit!');
        end
    end
    
    [bOk, stSysInfo] = checkSys(stSys);
    
    if ~bOk
        error('Fehler: Ungültige Systemdarstellung!');
    end

    
    stSys = standardizeSys(stSys);
    
    
    if ~strcmp(stSysInfo.eszFormat, 'sym');
        error('Fehler: System muss in symbolischer Form gegeben sein!');
    end
    
    if (stSysInfo.nParams ~= 0)
        error('Es dürfen keine Parameter mehr vorhanden sein!');
    end
    
    if (stSysInfo.bTimeVarying)
        error('Noch nicht implementiert: Zeitvariante Systeme!');
    end
    
    if (stSysInfo.nInputs > 1)
        error('Noch nicht implementiert: Anzahl Eingänge größer 1!');
    end


    n = stSysInfo.nStates;
    p = stSysInfo.nInputs;
    x = getSymMatrix(n, [], 'x');
    psi = getSymMatrix(n, [], 'psi');
    u = getSymMatrix(p, [], 'u');

    
    if (stSysInfo.bLinear)
        disp('Hinweis: Noch keine spezielle Implementierung für lineare Systeme!');
        disp('         System wird in nichtlineare Standardform f=f(x,u) umgeschrieben.');
        
        
        f = stSys.A * x + stSys.B * u;
    elseif (stSysInfo.bInputAffine)
        disp('Hinweis: Noch keine spezielle Implementierung für eingangsaffine Systeme!');
        disp('         System wird in nichtlineare Standardform f=f(x,u) umgeschrieben.');

        f = stSys.f + stSys.g * u;
    else
        f = stSys.f;
    end
    
    
    if any(size(Q) ~= n)
        error('Matrix Q muss Dimension (n x n) besitzen!');
    end

    if any(size(R) ~= p)
        error('Matrix R muss Dimension (p x p) besitzen!');
    end
    
    % Integrand Gütefunktional
    L = x.' * Q * x + u.' * R * u;

    % Hamilton-Funktion
    H = L + psi.' * f;

    
    dHdx = -jacobian(H,x)';

    seCanonicODE = [f;dHdx];

    seCtrlEq = diff(H,u);
    seU = solve(seCtrlEq, u);

    seCanonicODE = subs(seCanonicODE, u, seU);

    xpsi = getSymMatrix(2*n, [], 'xpsi');
    seCanonicODE = subs(seCanonicODE, [x;psi], xpsi);
    seU = subs(seU, [x;psi], xpsi);

    fctCanonicODE = sym2fct(seCanonicODE, {'t' 'xpsi'}, ...
                                                'ArgVecLen', [0 2*n]);

    fctCanonicBC = @(xpa, xpb) [xpa(1:n) - x0; xpb(1:n) - xT];

    
    if ~isempty(stTrajInit)
        solinit.x = stTrajInit.T.data;
        solinit.y = zeros(2*n, length(stTrajInit.T.data));
        solinit.y(1:n,:) = stTrajInit.X.data';
        
        % Anfangswerte Lagrange'sche Multiplikatoren aus
        % Steuerungsgleichung ermitteln.
        
        
    elseif ~isempty(stSolinit)
        solinit = stSolinit;
        
    else
        solinit.x = vTinit;
        solinit.y = zeros(2*n, length(vTinit));
        solinit.y(1:n,:) = interp1([0 T], [x0 xT]', vTinit, 'linear')';
    end


    bvpoptions = bvpset('Stats', 'on');
    sol = bvp4c(fctCanonicODE, fctCanonicBC, solinit, bvpoptions);


    fctU = sym2fct(seU, {'xpsi'}, 'ArgVecLen', 2*n);

    stTraj.T.data = sol.x';
    stTraj.X.data = sol.y(1:n,:)';
    %stTraj.P.data = sol.y(n:2*n,:)';

    stTraj.U.data = zeros(length(sol.x),1);
    for it = 1:length(sol.x)
        stTraj.U.data(it,:) = fctU(sol.y(:,it)');
    end % for it
    
    
    %stTraj.T = copySignalInfo(stTraj.T, stSys.t);
    stTraj.X = copySignalInfo(stTraj.X, stSys.x);
    stTraj.U = copySignalInfo(stTraj.U, stSys.u);
    

    if (stSysInfo.nOutputs > 0)
        [~, fctH] = sys2fcts(stSys, 'TimeVarying', true);
        
        q = stSysInfo.nOutputs;
        nT = length(stTraj.T.data);
        
        stTraj.Y.data = zeros(nT, q);
        for it = 1:nT
            stTraj.Y.data(it,:) = fctH( stTraj.X.data(it,:)', ...
                                            stTraj.U.data(it,:)', ...
                                            stTraj.T.data(it));
        end % for it

        stTraj.Y = copySignalInfo(stTraj.Y, stSys.y);
    end

    
    
    
    fctL = sym2fct(L, {'x' 'u'}, 'ArgVecLen', [n p]);
    
    fctL_t = @(t)fctL( interp1(stTraj.T.data, stTraj.X.data, t), ...
                        interp1(stTraj.T.data, stTraj.U.data, t) );
    
    fctL_tv = @(t) arrayfun( fctL_t, t );
    Lint = integral(fctL_tv, 0, T);
    
    stTraj.info.Fitness = Lint;
    
    stTraj.U.initdata = 0;
    stTraj.U.enddata = 0;
    
end % function getFeedForward_QR
