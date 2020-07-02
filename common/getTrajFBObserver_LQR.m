function [mL mA mB mC] = getTrajFBObserver_LQR(stSysLin, stTraj, Q, R, bPointwiseCARE, t0, P0)

    % Die Option nPointwiseCARE sollte immer false sein. (Ist nur für
    % Vergleich vorhanden, eine funktioniernde Regelung ergibt sich damit
    % nicht.)
    if (nargin < 5)
        bPointwiseCARE = false;
    end

    if (nargin < 6), t0 = []; end
    if (nargin < 7), P0 = []; end
    
      
    %Trajektorienfolgeregelung
    
    [fctA fctB fctC] = getLTVSysTraj(stSysLin, stTraj);
    vT = stTraj.T.data;
    
    fctAT = @(t) fctA(t)';
    fctCT = @(t) fctC(t)';

    if ~bPointwiseCARE
        mLT = lqr_tv(fctAT, fctCT, Q, R, vT, 't0', t0, 'P0', P0);
    else
        mLT = lqr_tv(fctAT, fctCT, Q, R, vT, 'PointwiseCARE', true);
    end
    
    mL = zeros(size(mLT,1), size(mLT,3), size(mLT,2));
    for iT = 1:size(mLT, 1)
        mL(iT,:,:) = shiftdim(mLT(iT,:,:), 1)';
    end % for iT

    
    nT = length(vT);
    A0 = fctA(0);
    B0 = fctB(0);
    C0 = fctC(0);
    mA = zeros(nT, size(A0,1), size(A0,2));
    mB = zeros(nT, size(B0,1), size(B0,2));
    mC = zeros(nT, size(C0,1), size(C0,2));
    
    for iT = 1:nT
        mL(iT,:,:) = shiftdim(mLT(iT,:,:), 1)';
        mA(iT,:,:) = fctA(vT(iT));
        mB(iT,:,:) = fctB(vT(iT));
        mC(iT,:,:) = fctC(vT(iT));
    end % for iT
    
end % getTrajFBObserver_LQR
