% function stSys = standardizeSys(stSys, bStdParam)
%
% Benennt die symbolischen Elemente der Signale x, u, t und ggf. p um
% x, u und ggf. p werden in x1, x2, ..., xn und entsprechend umbenannt.
% t wird in t umbenannt.
% Sofern das jeweilge Feld .name noch nicht existiert, wird dort der
% ersetzte Inhalt von .var gespeichert.
%
% Die Umbennenung wird auf alle in getSysStructFctFields() angegebenen,
% symbolsichen Funktionen angewandt.
%
% Wenn bStdParam = true, dann werden auch die Parameter in p1, ... pn
% umbenannt.
%
% Dient als vorbereitender Schritt, um von der Systemstruktur inline, m-
% oder c-Funktionen zu erzeugen.
%

function stSys = standardizeSys(stSys, varargin)

    p = inputParser();
    p.KeepUnmatched = false;
    p.addParamValue('StdParam', false, @islogical);
    p.addParamValue('WriteLog', true, @islogical);
    p.parse(varargin{:});

    bStdParam = p.Results.StdParam;
    bWriteLog = p.Results.WriteLog;


    clszFctFields = getSysStructFctFields();
    vbFields = isfield(stSys, clszFctFields);
    clszFctFields = clszFctFields(vbFields);
    
    
    [bXChanged, clszXNew, clszXOld, clszXTmp] = ...
                            getSignalVars(stSys, 'x', 'x', 'X_TMP', true);
    [bUChanged, clszUNew, clszUOld, clszUTmp] = ...
                            getSignalVars(stSys, 'u', 'u', 'U_TMP', true);
    [bTChanged, clszTNew, clszTOld, clszTTmp] = ...
                            getSignalVars(stSys, 't', 't', 'T_TMP', false);
    [bPChanged, clszPNew, clszPOld, clszPTmp] = ...
                            getSignalVars(stSys, 'p', 'p', 'P_TMP', true);
    [bX0Changed, clszX0New, clszX0Old, clszX0Tmp] = ...
                            getSignalVars(stSys, 'x0', 'x0', 'X0_TMP', true);
    [bU0Changed, clszU0New, clszU0Old, clszU0Tmp] = ...
                            getSignalVars(stSys, 'u0', 'u0', 'U0_TMP', true);
    
    if (~bStdParam)
        clszPNew = {};
        clszPTmp = {};
    end
    

    
    clszAll = [clszXOld clszUOld clszTOld clszPOld clszX0Old clszU0Old];
    
    if (~bStdParam)
        clszPOld = {};
    end
    
    clszOld = [clszXOld clszUOld clszTOld clszPOld clszX0Old clszU0Old];
    clszNew = [clszXNew clszUNew clszTNew clszPNew clszX0New clszU0New];
    clszTmp = [clszXTmp clszUTmp clszTTmp clszPTmp clszX0Tmp clszU0Tmp];

    if isempty(clszOld)
        %disp('Keine Variablen umzubenennen.');
    else
        % Alle Variablen die nicht ersetzt werden
        clszKeepVars = setdiff(clszAll, clszOld);

        % Fehler, wenn 
        vidConflicts = ismember(clszKeepVars, clszNew);
        vidConflicts = find(vidConflicts);

        if ~isempty(vidConflicts)
            disp('Folgende Variablen blockieren die Standardisierung:');
            for c = 1:length(vidConflicts)
                disp(['     ' clszKeepVars(vidConflicts(c))]);
            end % for c

            error('Standardisierung der Variablennamen nicht möglich!');
        end


        if ( bXChanged )
            stSys.x.var = clszXNew;
            if ~isfield(stSys.x, 'name')
                stSys.x.name = clszXOld;
            end
        end

        if ( bUChanged )
            stSys.u.var = clszUNew;
            if ~isfield(stSys.u, 'name')
                stSys.u.name = clszUOld;
            end
        end

        if ( bTChanged )
            stSys.t.var = clszTNew;
            if ~isfield(stSys.t, 'name')
                stSys.t.name = clszTOld;
            end
        end

        if ( bStdParam && bPChanged )
            stSys.p.var = clszPNew;
            if ~isfield(stSys.p, 'name')
                stSys.p.name = clszPOld;
            end
        end

        if ( bX0Changed )
            stSys.x0.var = clszX0New;
            if ~isfield(stSys.x0, 'name')
                stSys.x0.name = clszX0Old;
            end
        end        
        
        if ( bU0Changed )
            stSys.u0.var = clszU0New;
            if ~isfield(stSys.u0, 'name')
                stSys.u0.name = clszU0Old;
            end
        end

        for f = 1:length(clszFctFields)
            szFct = clszFctFields{f};

            if isa(stSys.(szFct), 'sym')
                stSys.(szFct) = subs(stSys.(szFct), clszOld, clszTmp);
                stSys.(szFct) = subs(stSys.(szFct), clszTmp, clszNew);
            end
        end % for f

        if bWriteLog
            stLog.Old = clszOld;
            stLog.New = clszNew;
            clLog = {'RenameVars' stLog};

            if isfield(stSys, 'log')
                stSys.log{end+1} = clLog;
            else
                stSys.log = {clLog};
            end
        end
    end
    
end % function standardizeSys


function [bChanged, clszNew, clszOld, clszTmp] = ...
                    getSignalVars(stSys, szSignal, ...
                                    szNewPrefix, szTmpPrefix, bVector)

    if ( isfield(stSys, szSignal) && isfield(stSys.(szSignal), 'var') )
        nS = length(stSys.(szSignal).var);

        if ( ~bVector && (nS > 1) )
            error(['Signal ''' szSignal ''' hat mehr als eine Komponente!']);
        elseif (~bVector)
            clszNew = {szNewPrefix};
            clszTmp = {szTmpPrefix};
            clszOld = stSys.(szSignal).var;
        else
            clszNew = getVarArray(szNewPrefix, nS);
            clszTmp = getVarArray(szTmpPrefix, nS);
            clszOld = stSys.(szSignal).var;
        end
    else
        clszNew = {};
        clszTmp = {};
        clszOld = {};
    end
    
     bChanged  = ( ~isequal(clszNew, clszOld) );
     
     if (~bChanged)
         clszNew = {};
         clszTmp = {};
         clszOld = {};
     end
    
end % subfunction getSignalVars
