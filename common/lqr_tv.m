function [mK mP] = lqr_tv(fctA, fctB, Q, R, vT, varargin)

    p = inputParser();
    p.KeepUnmatched = false;
    p.addParamValue('OdeSolver', @ode45, @(a) isa(a, 'function_handle'));
    p.addParamValue('OdeOptions', odeset(), @isstruct);
    p.addParamValue('PointwiseCARE', false, @islogical);
    p.addParamValue('t0', [], @isnumeric);
    p.addParamValue('P0', [], @isnumeric);
    p.addParamValue('Method', '', @ischar);
    p.addParamValue('NbIntervals', [], @isnumeric);
    p.parse(varargin{:});
    
    fctSolver = p.Results.OdeSolver;
    bCDRE = ~p.Results.PointwiseCARE;
    stOdeOptions = p.Results.OdeOptions;
    t0 = p.Results.t0;
    P0 = p.Results.P0;
    eszMethod = p.Results.Method;
    nIntervals = p.Results.NbIntervals;
    
    if bCDRE
        [P vT] = solveCDRE(fctA, fctB, Q, R, vT, ...
                                    fctSolver, stOdeOptions, ...
                                    t0, P0, eszMethod, nIntervals);
    else
        P = solveCARE(fctA, fctB, Q, R, vT);
    end
    
    Btmp = evalat(fctB, 0);
    n = size(Btmp,1);
    p = size(Btmp,2);
    
    mK = zeros(length(vT), p, n);
    
    mP = P;
    
    for i = 1:length(vT)
        t = vT(i);
              
        %Linearisierung um den aktuellen Punkt
        Bt = evalat(fctB, t);
        Rt = evalat(R, t);
    
        Pi = reshape(P(i, :), n, n);
        
        K = Rt \ (Bt' * Pi);
        % Schnellere und bessere Variante von: K(i,:) = inv(Rt) * Bt' * Pi;
        
        mK(i,:,:) = K;
    end % for i


end % function lqr_tv


function [P vT] = solveCDRE(fctA, fctB, Q, R, vT, ...
                                fctSolver, stOdeOptions, ...
                                t0, P0, eszMethod, nIntervals)

    if isempty(P0)
        if isempty(t0)
            t0 = vT(end);
        end
        
        A0 = evalat(fctA, t0);
        B0 = evalat(fctB, t0);
        Q0 = evalat(Q, t0);
        R0 = evalat(R, t0);

        % Anfangswert von P der Riccatigleichung
        P0 = care(A0, B0, Q0, R0);
    else
        if isempty(t0)
            error('FEHLER: Wenn P0 gegeben ist, dann muss auch t0 gegeben sein!');
        end
    end

    if isempty(eszMethod)
        if (isnumeric(fctA) && isnumeric(fctB) && isnumeric(Q) && isnumeric(R))
            eszMethod = 'modDavisonMaki';
        else
            eszMethod = 'direct';
        end
    end
    
    %Initialisierung der Riccati-Differentialgleichung
    fctRiccatiDGL = @(t, P) cdre_tv(t, P, fctA, fctB, Q, R);
    n = size(P0, 1);
    
    if ( vT == 2) % liegender Vektor?
        vT = vT';
    end
    
    if (t0 > vT(1)) % Integration nach links nötig?
        id0 = find( (vT <= t0), 1, 'last' );
        tspan = vT(1:id0);
        
        if (vT(id0) ~= t0)
            tspan = [tspan; t0];
        end
        
        tspan = flipud(tspan);
    
        if strcmp(eszMethod, 'direct')
            [vT_bw, P_bw] = fctSolver(fctRiccatiDGL, tspan, ...
                                                reshape(P0, 1, n*n), ...
                                                stOdeOptions);
        elseif strcmp(eszMethod, 'modDavisonMaki')
               [vT_bw, P_bw] = solveCDRE_modDavisonMaki(fctA, fctB, Q, R, ...
                                    tspan, P0, fctSolver, stOdeOptions, nIntervals);
        else
            error('UNGÜLTIGE OPTION: Method!');
        end
        
   
        vT_bw = flipud(vT_bw);
        P_bw = flipud(P_bw);
    else
        vT_bw = [];
        P_bw = [];
    end
    
    if (t0 < vT(end)) % Integration nach rechts nötig?
        id0 = find( (vT >= t0), 1, 'first' );
        tspan = vT(id0:end);
        
        if (vT(id0) ~= t0)
            tspan = [t0; tspan];
        end
        
        if strcmp(eszMethod, 'direct')
            [vT_fw, P_fw] = fctSolver(fctRiccatiDGL, tspan, ...
                                                reshape(P0, 1, n*n), ...
                                                stOdeOptions);
        elseif strcmp(eszMethod, 'modDavisonMaki')
            [vT_fw, P_fw] = solveCDRE_modDavisonMaki(fctA, fctB, Q, R, ...
                                    tspan, P0, fctSolver, stOdeOptions, nIntervals);
        else
            error('UNGÜLTIGE OPTION: Method!');
        end
        
                else
        vT_fw = [];
        P_fw = [];
    end
    
    if all(vT ~= t0)
        % Wenn t0 nicht ein Element von vT ist, dann diesen Zeitpunkt
        % wieder verwerfen.
        vT_bw = vT_bw(1:end-1);
        P_bw = P_bw(1:end-1,:);
        vT_fw = vT_fw(2:end);
        P_fw = P_fw(2:end,:);
    elseif ( ~isempty(vT_bw) && ~isempty(vT_fw) )
        % Falls t0 behalten werden soll und in beide Richtungen integriert
        % wurde, dann ist dieser Zeitpunkt doppelt vorhanden, muss also
        % einmal gelöscht werden.
        vT_fw = vT_fw(2:end);
        P_fw = P_fw(2:end,:);
    end
    
    vT = [vT_bw; vT_fw];
    P = [P_bw; P_fw];
    
end % subfunction lqr_cdre


function P = solveCARE(fctA, fctB, Q, R, vT)

    A0 = evalat(fctA, 0);
    n = size(A0, 1);
    
    P = zeros(length(vT), n^2);
    
    for i = 1:length(vT)
        t = vT(i);
              
        %Linearisierung um den aktuellen Punkt
        At = evalat(fctA, t);
        Bt = evalat(fctB, t);
        Qt = evalat(Q, t);
        Rt = evalat(R, t);
    
        Pi = care(At, Bt, Qt, Rt);
        P(i,:) = reshape(Pi, 1, n^2);
    end

end % subfunction lqr_care


function val = evalat(fct, t)
    
    if isnumeric(fct)
        val = fct;
    else
        val = fct(t);
    end

end % subfunction evalat


function [tspan mP] = solveCDRE_modDavisonMaki(...
                                A, B, Q, R, tspan, P0, odefct, odeoptions, nIntervals)

    n = size(P0,1);
    
    if (isnumeric(A) && isnumeric(B) && isnumeric(Q) && isnumeric(R))
        
        if isempty(nIntervals)
            nIntervals = 1000;
        end
        
        tspan_calc = linspace(tspan(1), tspan(end), nIntervals+1)';
        DT = tspan_calc(2) - tspan_calc(1);
        
        UV = [A, -B*inv(R)*B'; -Q, -A'];
        Phi = expm(UV * DT);
        Phi_11 = Phi(1:n,1:n);
        Phi_12 = Phi(1:n,n+1:end);
        Phi_21 = Phi(n+1:end,1:n);
        Phi_22 = Phi(n+1:end,n+1:end);

        mP_calc = zeros(length(tspan_calc), n^2);
        
        mP_calc(1,:) = reshape(P0, 1, n^2);
        Pk = P0;
        for k = 1:(length(tspan_calc)-1)
            Pkp = (Phi_21 + Phi_22 * Pk) * inv(Phi_11 + Phi_12 * Pk);
            mP_calc((k+1),:) = reshape(Pkp, 1, n^2);
            Pk = Pkp;
        end % for k
        
        mP = interp1(tspan_calc, mP_calc, tspan);
        
    else

        if isempty(nIntervals)
            nIntervals = 1;
        end

        tspan_calc = linspace(tspan(1), tspan(end), nIntervals + 1)';
        
        dUV = @(t, UV) ...
                reshape( [evalat(A,t),  ...
                            -evalat(B,t) * inv(evalat(R,t)) * evalat(B,t)';...
                            -evalat(Q,t), ...
                            -evalat(A,t)'] * reshape(UV, 2*n, n), ...
                        2*n^2, 1);

                    
        mP = zeros(length(tspan_calc), n^2);
        
        mP(1,:) = reshape(P0, 1, n^2);

        UVkp = [eye(n); P0];

        nK = length(tspan_calc) - 1;
        for k = 1:nK
            % Fortschrittsanzeige in Command Window
            szDisp = [num2str(k) '/' num2str(nK)];
            disp(szDisp);
            
            UVk = reshape(UVkp, 2*n^2, 1);

            [Tsolver UVsolver] = odefct(dUV, [tspan_calc(k) tspan_calc(k+1)]', UVk, odeoptions);

            UVkp = reshape(UVsolver(end,:), 2*n, n);
            Ukp = UVkp(1:n,:);
            Vkp = UVkp(n+1:end,:);
            Pkp = Vkp * inv(Ukp); 
            UVkp = [eye(n); Pkp];
            
            % Um ohnehin berechnete Lösungspunkte optimal auszunutzen,
            % werden jetzt P für alle geforderten Punkte, die in tspan_calc
            % liegen, berechnet
            if ( (tspan(2) - tspan(1)) > 0 )
                vID = find( (tspan >= Tsolver(1)) & (tspan <= Tsolver(end)) )';
            else
                vID = find( (tspan >= Tsolver(end)) & (tspan <= Tsolver(1)) )';
            end
            
            UV_ID = interp1(Tsolver, UVsolver, tspan(vID));
            
            for m = 1:length(vID)
                UVm = reshape(UV_ID(m,:), 2*n, n);
                Um = UVm(1:n,:);
                Vm = UVm(n+1:end,:);
                Pm = Vm * inv(Um); 
                mP(vID(m),:) = reshape(Pm, 1, n^2);
            end % for id

            % Löschen Fortschrittsanzeige in Command Window
            nDel = length(szDisp);
            disp(char(repmat(8, 1, nDel+2)));
        end % for k
    end
    
end % solveCDRE_modDavisonMaki
