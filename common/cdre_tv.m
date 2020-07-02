% Continious-differential-riccati-equation
% time-variant (or invariant) matrices A, B, Q, R

function P_dot = cdre_tv(t, P, fctA, fctB, fctQ, fctR)
    
    A = evalat(fctA, t);
    B = evalat(fctB, t);
    Q = evalat(fctQ, t);
    R = evalat(fctR, t);


    n = size(A, 1);
    
    P = reshape(P, n, n);
    
    P_dot = P * B * inv(R) * B' * P - P * A - A' * P - Q;
    
    P_dot = 0.5 * (P_dot + P_dot.');
    
    P_dot = reshape(P_dot, n*n, 1);

end % function cdre_tv


function val = evalat(fct, t)

    if isnumeric(fct)
        val = fct;
    else
        val = fct(t);
    end

end % subfunction evalat
