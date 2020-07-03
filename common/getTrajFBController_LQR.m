function mK = getTrajFBController_LQR(stSysLin, stTraj, Q, R, varargin)

    % Die Option nPointwiseCARE sollte immer false sein. (Ist nur für
    % Vergleich vorhanden, eine funktioniernde Regelung ergibt sich damit
    % nicht.)

    p = inputParser();
    p.KeepUnmatched = false;
    p.addParamValue('OdeSolver', @ode45, @(a) isa(a, 'function_handle'));
    p.addParamValue('OdeOptions', odeset(), @isstruct);
    p.addParamValue('PointwiseCARE', false, @islogical);
    p.addParamValue('t0', [], @isnumeric);
    p.addParamValue('P0', [], @isnumeric);
    p.parse(varargin{:});
    
    fctSolver = p.Results.OdeSolver;
    bPointwiseCARE = p.Results.PointwiseCARE;
    stOdeOptions = p.Results.OdeOptions;
    t0 = p.Results.t0;
    P0 = p.Results.P0;
    
      
    %Trajektorienfolgeregelung
    
    [fctA, fctB] = getLTVSysTraj(stSysLin, stTraj);
    vT = stTraj.T.data;

    if ~bPointwiseCARE
        mK = lqr_tv(fctA, fctB, Q, R, vT, 't0', t0, 'P0', P0, ...
                                        'OdeSolver', fctSolver, ...
                                        'OdeOptions', stOdeOptions);
        %odeparam = odeset('RelTol', 1e-6);
        %mK = lqr_tv(fctA, fctB, Q, R, vT, 'OdeOptions', odeparam);
    else
        mK = lqr_tv(fctA, fctB, Q, R, vT, 'PointwiseCARE', true);
    end
    
end % getTrajFBController_LQR
