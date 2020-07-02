function sys = setSysParam(sys, stParam, varargin)

    % Anstelle einer Struktur können auch zwei cell-Arrays übergeben
    % werden. Das erste enthält die Namen der Parameter, das zweite die
    % Werte.
    if isstruct(stParam)
        clszSetParams = fieldnames(stParam);
        clSetValues = struct2cell(stParam);
    elseif ( iscell(stParam) && ~isempty(varargin) )
        clszSetParams = stParam;
        clSetValues = varargin{1};
        
        varargin(1) = [];
    else
        error('Fehler: Unerwartete Argumente!');
    end
    
    p = inputParser();
    p.KeepUnmatched = false;
    p.addParamValue('Digits', -1, @isnumeric);
    p.addParamValue('WriteLog', true, @islogical);
    p.addParamValue('UseVarNames', false, @islogical);
    p.parse(varargin{:});

    uDigits = p.Results.Digits;
    bWriteLog = p.Results.WriteLog;
    bUseVarNames = p.Results.UseVarNames;


    if isfield(sys, 'params')
        pfield = 'params';
    elseif isfield(sys, 'p')
        pfield = 'p';
    else
        return;
    end
    
    
    if bUseVarNames
        clszSysParams = sys.(pfield).name;
    else
        clszSysParams = sys.(pfield).var;
    end
    
    
    [~, vidSet, vidSys] = intersect(clszSetParams, clszSysParams);
    
    if isempty(vidSet)
        disp('Keine Parameter ersetzt!');
        return;
    end
    
    % Ab hier wird immer mit den Variablen gearbeitet, auch wenn die
    % Parameter über den Namen identifiziert wurden
    clszSetParams = sys.(pfield).var(vidSys);
    clSetValues = clSetValues(vidSet);
    
    if (bWriteLog)
        stParamLog = cell2struct(clSetValues, clszSetParams);
    end
    
    
    bNoRemainingParams = ( length(vidSet) == length(clszSysParams) );
    
    if bNoRemainingParams
        % Falls alle Parameter ersetzt werden, dann Feld p komplett
        % löschen.
        sys = rmfield(sys, pfield);
    else
        % Falls Parameter nur teilweise ersetzt werden, dann die
        % dazugehörigen Einträge aus allen Feldern von p löschen.
        clszFields = fieldnames(sys.(pfield));
        for f = 1:length(clszFields)
            sys.(pfield).(clszFields{f})(vidSys) = [];
        end % for f
    end
    
    clszFctFields = getSysStructFctFields();
    clszFctFields = intersect(clszFctFields, fieldnames(sys));
    
    clszSetParams = clszSetParams(:);
    clSetValues = clSetValues(:);
    
    if (uDigits == 0)
        uDigits = digits();
    end
    
    for field = each_in(clszFctFields)
        field = field{1}; %#ok<FXSET>
        
        sys.(field) = subs(sys.(field), clszSetParams, clSetValues);
                                    
        if (uDigits ~= -1)
            sys.(field) = vpa(sys.(field), uDigits);
        end
    end % for f
    
    if (bWriteLog)
        clLog = { 'SetParam' stParamLog };
        if isfield(sys, 'log')
            sys.log{end+1} = clLog;
        else
            sys.log = {clLog};
        end
    end
    
    
    if bNoRemainingParams
        clszMatFields = {'A' 'B' 'C' 'D'};
        
        for field = each_in(clszMatFields)
            field = field{1}; %#ok<FXSET>
            
            if isfield(sys, field)
                %sys.(field) = double(sys.(field));
            end
        end % for fields
    end

end % function setSysParam
