function stSysLin = setLinPoint(stSysLin, x0, u0, t)

    clszXUT0Vars = {};
    clszXUT0Vals = {};
    
    if ( (~isempty(x0)) && isfield(stSysLin, 'x0') )
        clszXUT0Vars = [clszXUT0Vars stSysLin.x0.var];
        
        if isnumeric(x0)
            clszXUT0Vals = [clszXUT0Vals num2cell(x0')];
            stSysLin = rmfield(stSysLin, 'x0');
        else
            clszXUT0Vals = [clszXUT0Vals x0];
            stSysLin.x0.var = x0;
        end
    end
    
    if ( (~isempty(u0)) && isfield(stSysLin, 'u0') )
        clszXUT0Vars = [clszXUT0Vars stSysLin.u0.var];

        if isnumeric(u0)
            clszXUT0Vals = [clszXUT0Vals num2cell(u0')];
            stSysLin = rmfield(stSysLin, 'u0');
        else
            clszXUT0Vals = [clszXUT0Vals u0];
            stSysLin.u0.var = u0;
        end
    end

    if ( isfield(stSysLin, 't') && (~isempty(t)) )
        clszXUT0Vars = [clszXUT0Vars stSysLin.t.var];

        if isnumeric(t)
            clszXUT0Vals = [clszXUT0Vals num2cell(t')];
            stSysLin = rmfield(stSysLin, 't');
        else
            clszXUT0Vals = [clszXUT0Vals t];
            stSysLin.t.var = t;
        end
    end
    
    if ( isfield(stSysLin, 'A') && isa(stSysLin.A, 'sym') )
        stSysLin.A = subs(stSysLin.A, clszXUT0Vars, clszXUT0Vals);
    end
    
    if ( isfield(stSysLin, 'B') && isa(stSysLin.B, 'sym') )
        stSysLin.B = subs(stSysLin.B, clszXUT0Vars, clszXUT0Vals);
    end

    if ( isfield(stSysLin, 'C') && isa(stSysLin.C, 'sym') )
        stSysLin.C = subs(stSysLin.C, clszXUT0Vars, clszXUT0Vals);
    end

    if ( isfield(stSysLin, 'D') && isa(stSysLin.D, 'sym') )
        stSysLin.D = subs(stSysLin.D, clszXUT0Vars, clszXUT0Vals);
    end
    
end % function setLinPoint
