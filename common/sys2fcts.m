function varargout = sys2fcts(stSys, varargin)

    p = inputParser();
    p.KeepUnmatched = false;
    p.addParamValue('GetLinSysMat', false, @islogical);
    p.addParamValue('TimeVarying', true, @islogical);
    p.addParamValue('LinPointDep', false, @islogical);
    p.addParamValue('ParameterDep', 'none', @ischar);
    p.addParamValue('NumIfPossible', false, @islogical);
    p.parse(varargin{:});

    bGetLinSysMat = p.Results.GetLinSysMat;
    eszParameterDep = p.Results.ParameterDep;
    %'none', 'vec', 'struct', 'arglist'
    bLinPointDep = p.Results.LinPointDep;
    bTV = p.Results.TimeVarying;
    bNumIfPossible = p.Results.NumIfPossible;

    
    if (bGetLinSysMat)
        [fctA fctB fctC fctD stSysInfo] = getLinSysMatFcts(stSys, ...
                                                    bLinPointDep, ...
                                                    bTV, ...
                                                    eszParameterDep, ...
                                                    bNumIfPossible);

        varargout{1} = fctA;
        
        if (nargout > 1), varargout{2} = fctB; end
        if (nargout > 2), varargout{3} = fctC; end
        if (nargout > 3), varargout{4} = fctD; end
        if (nargout > 4), varargout{5} = stSysInfo; end
        
    else
        [fctF fctH stSysInfo] = getSysFcts(stSys, bTV, eszParameterDep);
        
        varargout{1} = fctF;
        
        if (nargout > 1), varargout{2} = fctH; end
        if (nargout > 2), varargout{3} = stSysInfo; end
            
    end

end % function sys2fcts
