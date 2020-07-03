function sys2sfct(stSys, szSFctName, eszType, varargin)

    p = inputParser();
    p.KeepUnmatched = false;
    p.addParamValue('Path', cd(), @ischar);
    p.addParamValue('ParamStructParam', -1, @isnumeric);
    p.addParamValue('CreateMaskedBlock', false, @islogical);
    p.addParamValue('CreateParamWrapper', false, @islogical);
    p.addParamValue('Compile', false, @islogical);    
    p.parse(varargin{:});

    szPath = p.Results.Path;
    eParam = p.Results.ParamStructParam;
    bCreateMaskedBlock = p.Results.CreateMaskedBlock;
    bCreateParamWrapper = p.Results.CreateParamWrapper;
    bCompile = p.Results.Compile;
    
    eszType = upper(eszType);
    
    if strcmp(eszType, 'C')
        bCSFct = true;
    elseif strcmp(eszType, 'M')
        bCSFct = false;
    else
        error('Ungültiger Wert für ''eszType''!');
    end

    if bCSFct
        szFullFctName = [szPath '\' szSFctName '.c'];
        szFullTemplateName = which('csfct_System_TEMPLATE.c');
    else
        szFullFctName = [szPath '\' szSFctName '.m'];
        szFullTemplateName = which('msfct_System_TEMPLATE.m');
    end
    
    [bOk, stSysInfo] = checkSys(stSys);
    
    if (~bOk)
        error('Ungültige Systemstruktur!');
    elseif ~( strcmp(stSysInfo.eszFormat, 'numeric') || ...
                    strcmp(stSysInfo.eszFormat, 'sym') )
        error('Erstellung einer s-Function nur für Formate ''numeric'' und ''sym'' möglich!');
    end
    
    stSys = standardizeSys(stSys);
    
    
    if (eParam == -1)
        bParam = isfield(stSys, 'p');
        if (bParam)
            disp('S-Function wird für Verwendung MIT Parameter-Struktur erstellt!');
        else
            disp('S-Function wird für Verwendung OHNE Parameter-Struktur erstellt!');
        end
    else
        bParam = (eParam == 1);
    end

    if ( ~bParam && isfield(stSys, 'p') )
        error('Es sind Parameter vorhanden! S-Function konnte nicht erstellt werden!');
    end
    
    stToken = getTokenStruct();
    
    stSysInfoAbout = stSysInfo;
    
    if (stSysInfo.nOutputs == 0)
        stSysInfoAbout.szOutputEqType = 'y=x';
    end
    
    stToken.SFCTNAME = szSFctName;
    
    if bCSFct
        stToken.ABOUT = ...
            getAboutText(stSysInfoAbout, szSFctName, bCSFct, 9); % TAB
    else
        stToken.ABOUT = ...
            getAboutText(stSysInfoAbout, szSFctName, bCSFct, '% ');
    end
    
    if bParam
        stToken.PARAMPARAM = '1';
        stToken.NPARAMS = num2str(stSysInfo.nParams);
        
        for p = 1:stSysInfo.nParams
            if (p > 1)
                stToken.PARAMFIELDS = [stToken.PARAMFIELDS ', '];
            end
            
            stToken.PARAMFIELDS = [stToken.PARAMFIELDS ...
                                        '"' stSys.p.name{p} '"'];
        end % for p
    else
        stToken.PARAMPARAM = '0';
        stToken.NPARAMS = '0';
        stToken.PARAMFIELDS = '{}';
    end
    
    stToken.NSTATES = num2str(stSysInfo.nStates);
    stToken.NINPUTS = num2str(stSysInfo.nInputs);
    if (stSysInfo.nOutputs == 0)
        stToken.NOUTPUTS = num2str(stSysInfo.nStates);
    else
        stToken.NOUTPUTS = num2str(stSysInfo.nOutputs);
    end
    
    if (stSysInfo.bDirectFeedthrough)
        stToken.BDIRECTFEEDTHROUGH = 'true';
    else
        stToken.BDIRECTFEEDTHROUGH = 'false';
    end
    
    
    if (stSysInfo.bLinear)
        
        svX = getSymVector('x', stSysInfo.nStates);
        
        if (stSysInfo.nInputs > 0)
            svU = getSymVector('u', stSysInfo.nInputs);
            
            clU = cell(stSysInfo.nInputs, 1);
            for u = 1:stSysInfo.nInputs
                clU{u} = char(svU(u));
            end % for u
        else
            clU = {};
        end
        
        seF = sym(stSys.A) * svX;

        if isfield(stSys, 'B')
            seF = seF + sym(stSys.B) * svU;
        end
        
        if (stSysInfo.nOutputs > 0)
            seH = sym(stSys.C) * svX;
            
            if isfield(stSys, 'D')
                seH = seH + sym(stSys.D) * svU;
            end
        else
            seH = getSymVector('x', stSysInfo.nStates);
        end
        
    else
        if (stSysInfo.bInputAffine)
            svU = getSymVector('u', stSysInfo.nInputs);

            seF = stSys.f + stSys.g * svU;
        else
            seF = stSys.f;
        end
        
        if (stSysInfo.nOutputs == 0)
            seH = getSymVector('x', stSysInfo.nStates);
        else
            seH = stSys.h;
        end

        if (stSysInfo.nInputs > 0)
            clU = stSys.u.var;
        else
            clU = {};
        end
        
        clX = stSys.x.var;

    end
    

    if (stSysInfo.nParams > 0)
        clP = stSys.p.var;
    else
        clP = {};
    end
    
    
    if (bCSFct)        
        szF = sym2cexpr(seF, { {'x' clX} ...
                                {'u' clU} ...
                                't' ...
                                {'p' clP} }, ...
                            'RetVarname', 'dx', ...
                            'WordWrap', true);
    
        szH = sym2cexpr(seH, { {'x' clX} ...
                                {'u' clU} ...
                                't' ...
                                {'p' clP} }, ...
                            'RetVarname', 'y', ...
                            'WordWrap', true);
                        
    else
        szF = sym2mexpr(seF, { {'x' clX} ...
                                {'u' clU} ...
                                't' ...
                                {'p' clP 'struct'} }, ...
                            'WordWrap', true);
    
        szH = sym2mexpr(seH, { {'x' clX} ...
                                {'u' clU} ...
                                't' ...
                                {'p' clP 'struct'} }, ...
                            'WordWrap', true);
    end


    stToken.STATEEQ = szF;
    stToken.OUTPUTEQ = szH;
    
    
    % Template laden
    fTemplateID = fopen(szFullTemplateName, 'rt');
    
    if (fTemplateID == -1)
        error(['Die Vorlage ''' szFullTemplateName ...
                                    ''' konnte nicht geöffnet werden!']);
    end

    fFctID = fopen(szFullFctName, 'wt');
    if (fFctID == -1)
        fclose(fTemplateID);
        error(['Die Zieldatei ''' szFullFctName ...
                        ''' konnte nicht zum schreiben geöffnet werden!']);
    end
    
    try
        while ~feof(fTemplateID)
            szCurLine = fgets(fTemplateID);
            
            szCurLine = replaceToken(szCurLine, stToken, '@@');
            
            fwrite(fFctID, szCurLine);
        end
        
    catch ME
        fclose(fTemplateID);
        fclose(fFctID);
        rethrow(ME);
    end

    fclose(fTemplateID);
    fclose(fFctID);
    
    if bCreateParamWrapper
        createParamWrapper(szPath, szSFctName, stSys.p.var);
    end
    
    if bCreateMaskedBlock
        createMaskedBlock(szSFctName, bCSFct, bParam, stSysInfoAbout);
    end
    
    if (bCompile)
        szCurPath = cd();
        
        cd(szPath)
        disp('Kompiliere ...');
        mex([szSFctName '.c']);
        disp('fertig!');
        cd(szCurPath);
    end
    
end % function sys2sfct


function stToken = getTokenStruct()

    stToken.SFCTNAME = '';
    stToken.ABOUT = '';
    stToken.PARAMPARAM = '';
    stToken.NSTATES = '';
    stToken.NINPUTS = '';
    stToken.NOUTPUTS = '';
    stToken.BDIRECTFEEDTHROUGH = '';
    stToken.STATEEQ = '';
    stToken.OUTPUTEQ = '';

    stToken.NPARAMS = '';
    stToken.PARAMFIELDS = '';

end % subfunction getTokenStruct


function szAbout = getAboutText(stSysInfo, szSFctName, bCSFct, ...
                                                            szLinePrefix)

    clszAbout = {};
    
    if (bCSFct)
        clszAbout{end+1} = ...
                        ['Level 2 c-s-function : ''' szSFctName '.c'''];
    else
        clszAbout{end+1} = ...
                        ['Level 2 m-s-function : ''' szSFctName '.m'''];
    end
    
    clszAbout{end+1} = ' ';
    clszAbout{end+1} = ['Created by sys2sfct at ' datestr(now) ' from the following system:'];
    clszAbout{end+1} = getSysInfoString(stSysInfo);

    szAbout = char(clszAbout);
    
    if ~isempty(szLinePrefix)
        szAbout = [repmat(szLinePrefix, size(szAbout, 1), 1) szAbout];
    end

end % subfunction getAboutText


function S = replaceToken(S, stTokens, szTokenDelimiter)
    
    uTokenDelLen = length(szTokenDelimiter);
    vidToken = findstr(S, szTokenDelimiter);
    
    while ~isempty(vidToken)
        if (vidToken < 2)
            error(['Ungültiges Token in ''' S '''']);
        end

        uStart = vidToken(1)+uTokenDelLen;
        uEnd = vidToken(2)-1;

        szToken = S(uStart:uEnd);
        if ~isfield(stTokens, szToken)
            error(['Keine Ersetzung für Token ''' szToken ''' in ''' S ''' angegeben!']);
        end
        
        uRepStart = vidToken(1);
        uRepEnd = vidToken(2) + uTokenDelLen - 1;
        
        szTokenVal = stTokens.(szToken);
        
        if (size(szTokenVal, 1) > 1)
            szTokenValTmp = deblank(szTokenVal(1,:));
            
            for l = 2:size(szTokenVal, 1)
                szTokenValTmp = [szTokenValTmp char(10) ...
                                                deblank(szTokenVal(l,:))]; %#ok<AGROW>
            end % for l
            szTokenVal = szTokenValTmp;
        end
        
        S = [S(1:uRepStart-1) szTokenVal S(uRepEnd+1:end)];

        vidToken = findstr(S, szTokenDelimiter);
    end

end % subfunction replaceToken


function createParamWrapper(szPath, szSFctName, clParams)

    szWrapperName = ['param2vec_' szSFctName];
    szFullWrapperName = [szPath '\' szWrapperName '.m'];
    
    fWrapper = fopen(szFullWrapperName, 'w');
    
    fprintf(fWrapper, 'function p = %s(stParam)\n\n', szWrapperName);
    for p = 1:length(clParams)
        fprintf(fWrapper, '\tp(%d) = stParam.%s;\n', p, clParams{p});
    end % for p
    fprintf(fWrapper, '\n end %% function %s\n', szWrapperName);
    
    fclose(fWrapper);
    
end % subfunction createParamWrapper


function createMaskedBlock(szSFctName, bCSFct, bParam, stSysInfo)

    load_system('simulink');
    
    hSystem = new_system();
    szSystem = get(hSystem, 'Name');
    open_system(szSystem);

    szBlk = [szSystem '/System'];
    
    if (bCSFct)
        add_block('simulink/User-Defined Functions/S-Function', szBlk);
    else
        add_block(...
            'simulink/User-Defined Functions/Level-2 M-file S-Function', ...
            szBlk);
    end


    vPos = get_param(szBlk, 'Position');
    vPos(3) = 1.5 * vPos(3);
    vPos(4) = 1.25 * vPos(4);
    set_param(szBlk, 'Position', vPos);


    % Maskierung aufbauen
    if (bParam)
        szMaskVariables = 'stParam=@1;vX0=@2;eszShowStatePort=@3';
        clszMaskPrompts = ...
                {'Parametersatz', 'Anfangszustand', 'Ausgang Zustände'};
        clszMaskStyles = {'edit' 'edit' 'checkbox'};
        clszMaskVisibilites = {'on' 'on' 'on'};
        clszMaskTunableValues = {'off' 'off' 'off'};
    else
        szMaskVariables = 'vX0=@1;eszShowStatePort=@2';
        clszMaskPrompts = {'Anfangszustand', 'Ausgang Zustände'};
        clszMaskStyles = {'edit' 'checkbox'};
        clszMaskVisibilites = {'on' 'on'};
        clszMaskTunableValues = {'off' 'off'};
    end


    set_param(szBlk, 'MaskVariables', szMaskVariables, ...
                        'MaskPrompts', clszMaskPrompts, ...
                        'MaskStyles', clszMaskStyles, ...
                        'MaskVisibilities', clszMaskVisibilites, ...
                        'MaskTunableValues', clszMaskTunableValues);


    set_param(szBlk, 'MaskDescription', ...
                        getAboutText(stSysInfo, szSFctName, bCSFct, ''));



    % Beschriftung
    vals = {};

    if (stSysInfo.nOutputs > 0)
        vals{end+1} = ['port_label(''output'', 1, ''y(' num2str( stSysInfo.nOutputs ) ')'')'];
    else
        vals{end+1} = ['port_label(''output'', 1, ''x(' num2str( stSysInfo.nStates ) ')'')'];
    end
    
    vals{end+1} = 'if strcmp(get_param(gcb(), ''eszShowStatePort''), ''on'')';
    vals{end+1} = ['    port_label(''output'', 2, ''x(' num2str( stSysInfo.nStates ) ')'')'];
    vals{end+1} = 'end';

    if (stSysInfo.nInputs > 0)
        vals{end+1} = ['port_label(''input'', 1, ''u(' num2str( stSysInfo.nInputs) ')'')'];
    end
    
    vals{end+1} = ['fprintf(''' stSysInfo.name '\n' stSysInfo.szStateEqType '\n' stSysInfo.szOutputEqType ''')'];

    set_param(szBlk, 'MaskDisplay', char(vals));


    % Blockparameter eintragen
    if (bParam)
        set_param(szBlk, 'Parameters', ...
            'stParam, vX0, double(strcmp(get_param(gcb(), ''eszShowStatePort''), ''on''))');
    else
        set_param(szBlk, 'Parameters', ...
            'vX0, double(strcmp(get_param(gcb(), ''eszShowStatePort''), ''on''))');
    end
    
    set_param(szBlk, 'vX0', mat2str(zeros(stSysInfo.nStates, 1)));
    set_param(szBlk, 'stParam', mat2str(zeros(stSysInfo.nParams, 1)));
    set_param(szBlk, 'eszShowStatePort', 0);
    
    %try %#ok<TRYNC>
        set_param(szBlk, 'FunctionName', szSFctName);
    %end

end % subfunction createMaskedBlock
