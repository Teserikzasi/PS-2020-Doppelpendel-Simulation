function stSysLin = linSys(stSys, x0, u0, t)

    if (nargin < 2), x0 = []; end
    if (nargin < 3), u0 = []; end
    if (nargin < 4), t = []; end

    nX = length(stSys.x.var);
    nU = length(stSys.u.var);
    
    for iX = 1:nX
        symX(iX,1) = sym(stSys.x.var{iX});
    end % for iX

    for iU = 1:nU
        symU(iU,1) = sym(stSys.u.var{iU});
    end % for iU
    
    if ~isfield(stSys, 'g')
        A = jacobian(stSys.f, symX);
        B = jacobian(stSys.f, symU);
    else
        A = jacobian(stSys.f, symX) + jacobian(stSys.g, symX) * symU;
        B = stSys.g;
    end
    
    if isfield(stSys, 'h')
        C = jacobian(stSys.h, symX);
        D = jacobian(stSys.h, symU);
    end

    if (isfield(stSys, 'name'))
        stSysLin.name = [stSys.name ' (Lin.)'];
    end
    
    if (isfield(stSys, 'desc'))
        stSysLin.desc = [stSys.desc ' (Linearisiert)'];
    end

    if (isempty(t) && isfield(stSys, 't'))
        stSysLin.t = stSys.t;
    end
        
    stSysLin.x = rmfield(stSys.x, 'var');
    stSysLin.x0 = stSys.x;
    
    stSysLin.u = rmfield(stSys.u, 'var');
    stSysLin.u0 = stSys.u;

    if isfield(stSys, 'p')
        stSysLin.p = stSys.p;
    end

    if isfield(stSys, 'h')
        stSysLin.y = stSys.y;
    end
    
    stSysLin.A = A;
    stSysLin.B = B;

    if isfield(stSys, 'h')
        stSysLin.C = C;
        stSysLin.D = D;
    end
    
    if ( ~isempty(x0) || ~isempty(u0) || ~isempty(t) )
        stSysLin = setLinPoint(stSysLin, x0, u0, t);
    end
    
end % function linSys
