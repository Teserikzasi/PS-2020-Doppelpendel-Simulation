function [bOk stSysInfo] = checkSys(stSys)

    % Rein NL oder lin?
    % Anzahl x,u,y (x0,u0) passt?
    % Variablennamen doppelt? (Eingangsgrößen können keine Zustandsgrößen
    % sein, aber Ausgangsgrößen können auch als Ein- oder Zustandsgrößen
    % vorkommen)
    % Alle in Gleichungen vorkommenden Variablen angegeben
    % h bzw C/D angegeben, ohne y
    % y angegeben ohne h bzw C/D
    
    % Ts Samplingrate
    
    % Warnungen
    % t angegeben, obwohl nicht verwendet?
    % Mehr p-Variablen als verwendet angegeben

    bOk = true;
    clszErrors = {};
    
    stSysInfo = [];
    
    bF = isfield(stSys, 'f');
    bG = isfield(stSys, 'g');
    bH = isfield(stSys, 'h');
    bA = isfield(stSys, 'A');
    bB = isfield(stSys, 'B');
    bC = isfield(stSys, 'C');
    bD = isfield(stSys, 'D');
    
    % Prüfen, dass linear und nicht-linear nicht gemischt
    if ( (bA || bB || bC || bD) && (bF || bG || bH) )
        clszErrors{end+1} = 'Vermischung von linearer und nicht-linearer Form!';
    end
    
    if (bA || bB || bC || bD)
        bLin = true;
    elseif (bF || bG || bH)
        bLin = false;
    else
        clszErrors{end+1} = 'Keine Funktion angegeben!';
    end
    
    if ~isempty(clszErrors)
        disp('Folgende Fehler sind aufgetreten:');
        disp(char(clszErrors));
        bOk = false;
        return;
    end
    
    
    [nStates clszCurErrors bXVar bXUnit clszXNames clszXUnits clszXVars] = ...
                                                checkSignal(stSys, 'x');
    if ~isempty(clszCurErrors)
        clszErrors = [clszErrors clszCurErrors];
    end
    
    if (nStates == 0)
        clszErrors{end+1} = 'Keine Zustände angegeben!';
    end
                                            
    [nInputs clszCurErrors bUVar bUUnit clszUNames clszUUnits clszUVars] = ...
                                                checkSignal(stSys, 'u');
    if ~isempty(clszCurErrors)
        clszErrors = [clszErrors clszCurErrors];
    end

    [nOutputs clszCurErrors bYVar bYUnit clszYNames clszYUnits clszYVars] = ...
                                                checkSignal(stSys, 'y');
    if ~isempty(clszCurErrors)
        clszErrors = [clszErrors clszCurErrors];
    end

    [nTimes clszCurErrors bTVar bTUnit clszTNames clszTUnits clszTVars] = ...
                                                checkSignal(stSys, 't');
    if ~isempty(clszCurErrors)
        clszErrors = [clszErrors clszCurErrors];
    end
    
    if (nTimes > 0)
        if (nTimes > 1)
            clszErrors{end+1} = 'Mehr als eine Zeitvariable angegeben!';
        end
        
        bTV = true;
        
        if isfield(stSys.t, 'data')
            nTData = length(stSys.t.data);
            if (nTData == 0)
                clszErrors{end+1} = 'Zeitvektor ''t.data'' angegeben, aber Länge Null!';
            elseif ( (nTData == nStates) || (nTData == nInputs) || (nTData == nOutputs) )
                clszErrors{end+1} = 'Länge ''t.data'' gleich Anzahl Zustände, Eingägne und/oder Ausgänge!';
            end
        else
            nTData = 0;
        end
    else
        bTV = false;
        nTData = 0;
    end
    
    [nParams clszCurErrors bPVar bPUnit clszPNames clszPUnits clszPVars] = ...
                                                checkSignal(stSys, 'p');
    if ~isempty(clszCurErrors)
        clszErrors = [clszErrors clszCurErrors];
    end
    
    
    [nX0 clszCurErrors bX0Var bX0Unit clszX0Names clszX0Units clszX0Vars] = ...
                                                checkSignal(stSys, 'x0');
    if ~isempty(clszCurErrors)
        clszErrors = [clszErrors clszCurErrors];
    end
    
                                        
    [nU0 clszCurErrors bU0Var bU0Unit clszU0Names clszU0Units clszU0Vars] = ...
                                                checkSignal(stSys, 'u0');
    if ~isempty(clszCurErrors)
        clszErrors = [clszErrors clszCurErrors];
    end    
    

    % Abkürzungen
    bU = (nInputs > 0);
    bY = (nOutputs > 0);
    
    szXNames = cells2cslist(clszXNames);
    szXUnits = cells2cslist(clszXUnits);
    szUNames = cells2cslist(clszUNames);
    szUUnits = cells2cslist(clszUUnits);
    szYNames = cells2cslist(clszYNames);
    szYUnits = cells2cslist(clszYUnits);
    szTNames = cells2cslist(clszTNames);
    szTUnits = cells2cslist(clszTUnits);
    szPNames = cells2cslist(clszPNames);
    szPUnits = cells2cslist(clszPUnits);
    szX0Names = cells2cslist(clszX0Names);
    szX0Units = cells2cslist(clszX0Units);
    szU0Names = cells2cslist(clszU0Names);
    szU0Units = cells2cslist(clszU0Units);
    
    clszXU0Vars = union(clszX0Vars, clszU0Vars);
    
    % Prüfen, ob sich Namen und/oder Variablennamen überschneiden
    if ~isempty(intersect(clszXNames, clszUNames))
        clszErrors{end+1} = 'Überschneidung bei Namen von x und u!';
    end
    if ~isempty(intersect(clszXVars, clszUVars))
        clszErrors{end+1} = 'Überschneidung bei Variablen von x und u!';
    end
    
    if ~isempty(intersect(clszXNames, clszTNames))
        clszErrors{end+1} = 'Überschneidung bei Namen von x und t!';
    end
    if ~isempty(intersect(clszXVars, clszTVars))
        clszErrors{end+1} = 'Überschneidung bei Variablen von x und t!';
    end

    if ~isempty(intersect(clszXNames, clszPNames))
        clszErrors{end+1} = 'Überschneidung bei Namen von x und p!';
    end
    if ~isempty(intersect(clszXVars, clszPVars))
        clszErrors{end+1} = 'Überschneidung bei Variablen von x und p!';
    end

    if ~isempty(intersect(clszUNames, clszTNames))
        clszErrors{end+1} = 'Überschneidung bei Namen von u und t!';
    end
    if ~isempty(intersect(clszUVars, clszTVars))
        clszErrors{end+1} = 'Überschneidung bei Variablen von u und t!';
    end

    if ~isempty(intersect(clszUNames, clszPNames))
        clszErrors{end+1} = 'Überschneidung bei Namen von u und p!';
    end
    if ~isempty(intersect(clszUVars, clszPVars))
        clszErrors{end+1} = 'Überschneidung bei Variablen von u und p!';
    end

    if ~isempty(intersect(clszTNames, clszPNames))
        clszErrors{end+1} = 'Überschneidung bei Namen von t und p!';
    end
    if ~isempty(intersect(clszTVars, clszPVars))
        clszErrors{end+1} = 'Überschneidung bei Variablen von t und p!';
    end

    % Prüfen, ob nichtverwendete t und p
    % Feststellen aller verwendeter symbolischer Variablen
    %clszUsedVars = getAllUsedVars(stSys);
    
    
    if ~isempty(clszErrors)
        disp('Folgende Fehler sind bei der Überprüfung der Signale aufgetreten:');
        disp(char(clszErrors));
        bOk = false;
        return;
    end
    
    
    if (bLin)
        bLinear = true;
        
        if (bXVar || bYVar || bUVar)
            clszErrors{end+1} = 'Bei linearer Form dürfen für x, u und y keine ''var'' angeben sein!';
        end
        
        if (~bA)
            clszErrors{end+1} = 'Bei linearer Form muss mind. A angegeben sein!';
        end
        
        if ( ~(bB || bD) && bU )
            clszErrors{end+1} = 'Wenn B und D nicht angegeben, dann darf kein u angegeben sein!';
        end

        if ( ~(bC || bD) && bY )
            clszErrors{end+1} = 'Wenn C und D nicht angegeben, dann darf kein y angegeben sein!';
        end
        
        if (bA)
             [clszCurErrors eszAFormat bA_TV] = checkMatrix(stSys.A, 'A', ...
                                                     nStates, nStates, ...
                                                     clszPVars, clszTVars, ...
                                                    clszXU0Vars, ...
                                                     nTData);        
            
            if ~isempty(clszCurErrors)
                clszErrors = [clszErrors clszCurErrors];
            end
        else
            eszAFormat = '';
            bA_TV = false;
        end
        
        if (bB)
             [clszCurErrors eszBFormat bB_TV] = checkMatrix(stSys.B, 'B', ...
                                                     nStates, nInputs, ...
                                                     clszPVars, clszTVars, ...
                                                    clszXU0Vars, ...
                                                     nTData);
            if ~isempty(clszCurErrors)
                clszErrors = [clszErrors clszCurErrors];
            end
        else
            eszBFormat = '';
            bB_TV = false;
        end
            
        if (bC)
            [clszCurErrors eszCFormat bC_TV] = checkMatrix(stSys.C, 'C', ...
                                                     nOutputs, nStates, ...
                                                     clszPVars, clszTVars, ...
                                                    clszXU0Vars, ...
                                                     nTData);
            if ~isempty(clszCurErrors)
                clszErrors = [clszErrors clszCurErrors];
            end
        else
            eszCFormat = '';
            bC_TV = false;
        end

        if (bD)
            [clszCurErrors eszDFormat bD_TV] = checkMatrix(stSys.D, 'D', ...
                                                     nOutputs, nInputs, ...
                                                     clszPVars, clszTVars, ...
                                                    clszXU0Vars, ...
                                                     nTData);
            if ~isempty(clszCurErrors)
                clszErrors = [clszErrors clszCurErrors];
            end
        else
            eszDFormat = '';
            bD_TV = false;
        end
        
        
        clszFormats = {eszAFormat eszBFormat eszCFormat eszDFormat};
        
        if ( sum(ismember({'numeric_table' 'sym' 'function_handle'}, ...
                                                        clszFormats)) > 1 )
            clszErrors{end+1} = 'Sich ausschließende Formate verwendet:';
            clszErrors{end+1} = ['    A: ' eszAFormat];
            clszErrors{end+1} = ['    B: ' eszAFormat];
            clszErrors{end+1} = ['    C: ' eszAFormat];
            clszErrors{end+1} = ['    D: ' eszAFormat];
        else
            if ismember('numeric_table', clszFormats)
                eszFormat = 'numeric_table';
            elseif ismember('sym', clszFormats)
                eszFormat = 'sym';
            elseif ismember('function_handle', clszFormats)
                eszFormat = 'function_handle';
            elseif ismember('numeric', clszFormats)
                eszFormat = 'numeric';
            else
                error('Unbekanntes Format! Implementierung checkSys überprüfen!');
            end
        end
        
        
        bInputAffine = bB;
        bDirectFeedthrough = bD;
        bOutputEq = bC || bD;
        
        if (bA_TV)
            szStateEqType = 'dx=A(t)*x';
        else
            szStateEqType = 'dx=A*x';
        end
        
        if (bB && bB_TV)
            szStateEqType = [szStateEqType '+B(t)*u'];
        elseif (bB)
            szStateEqType = [szStateEqType '+B*u'];
        end
        
        if (bC && bC_TV)
            szOutputEqType = 'y=C(t)*x';
        elseif (bC)
            szOutputEqType = 'y=C*x';
        else
            szOutputEqType = '';
        end
        
        if (bD && bD_TV)
            szOutputEqType = [szOutputEqType '+D(t)*u'];
        else
            szOutputEqType = [szOutputEqType '+D*u'];
        end
        
        if ( bTV && ~(bA_TV || bB_TV || bC_TV || bD_TV) )
            clszErrors{end+1} = 'Zeitsignal t ist gegeben, aber keine der Matrizen A, B, C und D ist zeitvariant!';
        end
        
        if bTV
            szType = 'LTV';
        else
            szType = 'LTI';
        end

    else % bLin == false
        bLinear = false;

        %bInputAffine = bG;

        
        if (~bF)
            clszErrors{end+1} = 'Bei nichtlinearer Form muss mind. f angegeben sein!';
        end
        
        if ( ~bH && bY )
            clszErrors{end+1} = 'Wenn h nicht angegeben, dann darf kein y angegeben sein!';
        end
        
        eszFFormat = getFctFormat(stSys, 'f');
        eszGFormat = getFctFormat(stSys, 'g');
        eszHFormat = getFctFormat(stSys, 'h');
        
        % Entweder sind alle Funktionen symbolisch gegeben, oder alle als
        % Function-Handles
        
        clszFormats = {eszFFormat eszGFormat eszHFormat};
        clszFormat = unique(clszFormats);
        clszFormat = setdiff(clszFormat, {''});
        
        if ( length( clszFormat ) > 1 )
            clszErrors{end+1} = 'Die einzelnen Funktionen besitzen verschiedene Formate:';
            clszErrors{end+1} = ['    f: ' eszFFormat];
            clszErrors{end+1} = ['    g: ' eszGFormat];
            clszErrors{end+1} = ['    h: ' eszHFormat];
        else
            eszFormat = clszFormat{1};
            
            if ~( strcmp(eszFormat, 'sym') || ...
                                    strcmp(eszFormat, 'function_handle') )
                clszErrors{end+1} = ['Format ''' eszFormat ''' für nicht-lineare Systeme nicht zulässig!'];
            end
        end
        
        if ~isempty(clszErrors)
            disp('Bei Überprüfung aufgetretende Fehler:');
            disp(char(clszErrors));
            bOk = false;
            return;
        end
        
        
        % Abkürzung
        bSym = strcmp(eszFormat, 'sym');
        
        clArgGroups = { {clszXVars, 'x'}, {clszUVars, 'u'}, ...
                                {clszTVars, 't'}, {clszPVars, 'p'} };
                            
        
        if (~bSym)
            
            if (bX_var || bU_var || bY_var || bT_var || bP_var)
                clszErrors{end+1} = 'Wenn die Funktionen durch Function-Handles gegeben, dann dürfen x.var, u.var, y.var, t.var und p.var nicht vorhanden sein!';
            end
            
        end
            % Wenn die Funktionen als function-handle angegeben sind, dann
            % ist die Reihenfolge der Argumente immer wie foglgt:
            %    Das erste Argument ist immer der Zustandsvektor
            %    f( x [, u] [, t] [, p] )
            % Das Argument "u" ist genau dann vorhanden, wenn das Feld 'u'
            % in stSys vorhanden ist UND g nicht angegeben ist.
            % "t" und "p" sind genau dann vorhanden, wenn das Feld 't' bzw.
            % 'p' in stSys vorhanden ist.
            % "u", "t" und/oder "p" sind immer Vektoren mit der Länge 
            
        [clszCurErrors clszFVars] = getArgNames(stSys, 'f', clArgGroups);
        if ~isempty(clszCurErrors)
            clszErrors = [clszErrors clszCurErrors];
        end
        
        [clszCurErrors clszGVars] = getArgNames(stSys, 'g', clArgGroups);
        if ~isempty(clszCurErrors)
            clszErrors = [clszErrors clszCurErrors];
        end
        
        [clszCurErrors clszHVars] = getArgNames(stSys, 'h', clArgGroups);
        if ~isempty(clszCurErrors)
            clszErrors = [clszErrors clszCurErrors];
        end


        clszFArgGrps = getArgGroups(clszFVars, clArgGroups);
        clszGArgGrps = getArgGroups(clszGVars, clArgGroups);
        clszHArgGrps = getArgGroups(clszHVars, clArgGroups);
        
        % String mit Argumentgruppen erhalten, Argumentgruppe "p" dabei
        % ignorieren
        szFArgs = getArgString(clszFArgGrps, {'p'});
        szGArgs = getArgString(clszGArgGrps, {'p'});
        szHArgs = getArgString(clszHArgGrps, {'p'});


        % Prüfen, ob unbekannte Variablen benutzt worden sind
        clszUsedVars = [clszFVars clszGVars clszHVars];
        clszGivenVars = [clszXVars clszUVars clszTVars clszPVars];

        vidUndeclared = find(ismember(clszUsedVars, clszGivenVars) == false);

        if ~isempty(vidUndeclared)
            clszErrors{end+1} = 'Folgende Variablen sind verwendet, aber weder x, u, t oder p zugeordnet:';

            for u = 1:length(vidUndeclared)
                clszErrors{end+1} = ['     ' clszUsedVars{vidUndeclared(u)}];
            end
        end

        % Prüfen, ob Parameter nicht benutzt worden sind
        vidUnusedP = find(ismember(clszPVars, clszUsedVars) == false);
        if ~isempty(vidUnusedP)
            clszErrors{end+1} = 'Folgende Parameter sind nicht verwendet:';

            for u = 1:length(vidUnusedP)
                clszErrors{end+1} = ['     ' clszPVars{vidUnusedP(u)}];
            end
        end

        % Prüfen, ob Eingangsgrößen in Ausgangsgleichung vorkommen
        bDirectFeedthrough = any( ismember(clszUVars, clszHVars) );

        % Für jede Funktion prüfen, ob zeitvariant
        bF_TV = any( ismember(clszTVars, clszFVars) );
        bG_TV = any( ismember(clszTVars, clszGVars) );
        bH_TV = any( ismember(clszTVars, clszHVars) );

        if (bTV && ~( bF_TV || bG_TV || bH_TV ))
            clszErrors{end+1} = 'Zeitsignal ''t'' angegeben, aber f, g und h zeitinvariant!';
        end

        bInputAffine = bG;

        if (bInputAffine)
            if ( any(ismember(clszUVars, clszFVars)) )
                clszErrors{end+1} = 'System eingangs-affin (''g'' angegeben), aber Eingangsgrößen kommen in ''f'' vor!';
            elseif ( any(ismember(clszUVars, clszGVars)) )
                clszErrors{end+1} = 'System eingangs-affin (''g'' angegeben), aber Eingangsgrößen kommen in ''g'' vor!';
            end
        end
        
        szStateEqType = ['dx=f(' szFArgs ')'];
        
        if (bG)
            szStateEqType = [szStateEqType '+g(' szGArgs ')*u'];
        end
        
        bOutputEq = bH;
        
        if (bH)
            szOutputEqType = ['y=h(' szHArgs ')'];
        else
            szOutputEqType = '';
        end
        
        
        if (bF_TV || bG_TV || bH_TV)
            szType = 'NLTV';
        else
            szType = 'NLTI';
        end

        if (bG)
            szType = [szType ' (input affine)'];
        end
        
    end
    
    if ~isempty(clszErrors)
        disp('Folgende Fehler sind bei der Überprüfung der Funktionen aufgetreten:');
        disp(char(clszErrors));
        bOk = false;
        return;
    end
    
    
    if (nargout == 2)
        if isfield(stSys, 'name')
            stSysInfo.name = stSys.name;
        else
            stSysInfo.name = '';
        end

        if isfield(stSys, 'desc')
            stSysInfo.desc = stSys.desc;
        else
            stSysInfo.desc = '';
        end
        
        stSysInfo.nStates = nStates;
        stSysInfo.nInputs = nInputs;
        stSysInfo.nOutputs = nOutputs;
        
        stSysInfo.nParams = nParams;
        
        stSysInfo.bLinear = bLinear;
        stSysInfo.bInputAffine = bInputAffine;
        stSysInfo.bTimeVarying = bTV;
        stSysInfo.bDirectFeedthrough = bDirectFeedthrough;
        stSysInfo.bLinPointDependent = ~isempty(clszXU0Vars);
        
        stSysInfo.eszFormat = eszFormat;

        stSysInfo.bOutputEq = bOutputEq;
        stSysInfo.szType = szType;
        stSysInfo.szStateEqType = szStateEqType;
        stSysInfo.szOutputEqType = szOutputEqType;
        
        stSysInfo.szXNames = szXNames;
        stSysInfo.szXUnits = szXUnits;
        stSysInfo.szXVars = cells2cslist(clszXVars);
        
        stSysInfo.szUNames = szUNames;
        stSysInfo.szUUnits = szUUnits;
        stSysInfo.szUVars = cells2cslist(clszUVars);

        stSysInfo.szTNames = szTNames;
        stSysInfo.szTUnits = szTUnits;
        stSysInfo.szTVars = cells2cslist(clszTVars);

        stSysInfo.szPNames = szPNames;
        stSysInfo.szPUnits = szPUnits;
        stSysInfo.szPVars = cells2cslist(clszPVars);
        
        stSysInfo.szYNames = szYNames;
        stSysInfo.szYUnits = szYUnits;
        stSysInfo.szYVars = cells2cslist(clszYVars);
        
        stSysInfo.szX0Names = szX0Names;
        stSysInfo.szX0Units = szX0Units;
        stSysInfo.szX0Vars = cells2cslist(clszX0Vars);

        stSysInfo.szU0Names = szU0Names;
        stSysInfo.szU0Units = szU0Units;
        stSysInfo.szU0Vars = cells2cslist(clszU0Vars);
    end
    
end % function checkSys


function [clszErrors clszArgs] = getArgNames(stSys, szFct, clArgGroups)

    clszErrors = {};
    clszArgs = {};
    
    if ~isfield(stSys, szFct)
        return;
    end
    
    fct = stSys.(szFct);

    if isa(fct, 'sym')
        clszArgs = findsymcells(fct);
    elseif isa(fct, 'function_handle')
        szFctString = char(fct);
        
        if (szFctString(1) ~= '@')
            clszErrors{end+1} = ['Funktion ''' szFct ''' ist Handle auf "named function"! Es sind aber nur Handle auf anonyme Funktionen zulässig!'];
        else
            iStart = strfind(szFctString, '(');
            iStart = iStart(1) + 1;

            iEnd = strfind(szFctString, ')');
            iEnd = iEnd(1) - 1;

            szArgs = szFctString(iStart:iEnd);

            viArgStart = [1, strfind(szArgs, ',')+1];

            clszArgGrps = cell(1, length(viArgStart));

            for a = 1:length(viArgStart)-1
                clszArgGrps{a} = szArgs(viArgStart(a):viArgStart(a+1)-2);
            end
            clszArgGrps{end} = szArgs(viArgStart(end):end);
            
            clszArgs = {};
            for c = 1:length(clszArgGrps)
                szCurGrp = clszArgGrps{c};
                
                for g = 1:length(clArgGroups)
                    szGrp = clArgGroups{g}{2};
                    
                    if strcmp(szCurGrp, szGrp)
                        clszArgs = [clszArgs clArgGroups{g}{1}];
                        break;
                    end
                end % for g
            end % for c
        end
    end

end % subfunction getArgNames


function szArgs = getArgString(clszArgs, clszIgnoreArgs)

    [tmp vidArgs] = setdiff(clszArgs, clszIgnoreArgs);
    
    clszArgs = clszArgs(sort(vidArgs));
    
    szArgs = '';
    for a = 1:length(clszArgs)
        szArgs = [szArgs ',' clszArgs{a}];
    end
    szArgs = szArgs(2:end);
    
end % subfunction getArgString


function clszArgs = getArgGroups(clszVars, clArgGroups)

    clszArgs = {};

    for g = 1:length(clArgGroups)
        if any(ismember(clArgGroups{g}{1}, clszVars)), 
            clszArgs{end+1} = clArgGroups{g}{2};
        end
    end % for g
    
end % subfunction getSymFctArgGroups




function [nLen clszErrors bVar bUnit clszNames clszUnits clszVars] = ...
                                            checkSignal(stSys, szSignal)

    clszErrors = {};
    bVar = false;
    bUnit = false;
    clszNames = {};
    clszVars = {};
    clszUnits = {};
    
    if isfield(stSys, szSignal)
        stSignal = stSys.(szSignal);
    else
        nLen = 0;
        return;
    end
    
    if ~isfield(stSignal, 'name')
        clszErrors{end+1} = ['Für Signal ''' szSignal ''' keine Namen angegeben!'];
        nLen = -1;
        return;
    end
    
    nLen = length(stSignal.name);
    
    if (nLen == 0)
        clszErrors{end+1} = ['Signal ''' szSignal ''' vorhanden, aber ''name'' ist leer!'];
        return;
    end
    
    clszNames = stSignal.name;
    
    if isfield(stSignal, 'var')
        if (length(stSignal.var) ~= nLen)
            clszErrors{end+1} = ['Für Signal ''' szSignal ''' Felder ''name'' und ''var'' unterschiedlich lang!'];
        end
        bVar = true;
        clszVars = stSignal.var;
    end
    
    if isfield(stSignal, 'unit')
        if (length(stSignal.unit) ~= nLen)
            clszErrors{end+1} = ['Für Signal ''' szSignal ''' Felder ''name'' und ''unit'' unterschiedlich lang!'];
        end
        clszUnits = stSignal.unit;
        bUnit = true;
    end

end % subfunction checkSignal


% clszError = {}    Kein Fehler, 
% Es wird davon ausgegangen, das die Matrix existiert!
function [clszError eszFormat bTV] = checkMatrix(matrix, szMatrix, ...
                                                    nRExp, nCExp, ...
                                                    clszPVars, clszTVars, ...
                                                    clszXU0Vars, ...
                                                    nTData)
    bTV = false;
    eszFormat = '';
    clszError = {};
    
    
    if isnumeric(matrix)
        if ( (size(matrix, 1) == nRExp) && ...
                    (size(matrix, 2) == nCExp) && (size(matrix, 3) == 1) )
            eszFormat = 'numeric';
        elseif ( (size(matrix, 1) == nTData) && ...
                                        (size(matrix, 2) == nRExp) && ...
                                        (size(matrix, 3) == nCExp) )
            eszFormat = 'numeric_table';
        else
            if (nTData == 0)
                clszError{end+1} = ['Matrix ''' szMatrix ''' hat nicht die Dimension (' num2str(nRExp) 'x' num2str(nCExp) ')!'];
            else
                clszError{end+1} = ['Matrix ''' szMatrix ''' hat nicht die Dimension (' num2str(nRExp) 'x' num2str(nCExp) '), oder (' num2str(nTData) 'x' num2str(nRExp) 'x' num2str(nCExp) ')!'];
            end
        end

    elseif isa(matrix, 'sym')
        eszFormat = 'sym';

        if ~( (size(matrix, 1) == nRExp) && (size(matrix, 2) == nCExp) )
            clszError{end+1} = ['Matrix ''' szMatrix ''' hat nicht die Dimension (' num2str(nRExp) 'x' num2str(nCExp) ')!'];
        end
        % Prüfen, ob nur Variablen aus p und t vorkommen
        clszVars = findsymcells(matrix);
        
        if isempty(clszVars)
            bTV = false;
        else
            bTV = any(ismember(clszTVars, clszVars));
        end
        
        clszKnownVars = union(clszPVars, clszTVars);
        clszKnownVars = union(clszKnownVars, clszXU0Vars);
        
        clszAddVars = setdiff(clszVars, clszKnownVars);
        if ~isempty( clszAddVars )
            clszError{end+1} = ['In Matrix ''' szMatrix ''' werden folgende Variablen verwendet,'];
            clszError{end+1} = 'die weder ''t'', ''p'', ''x0'' noc ''u0'' zugeordnet sind:';
            for v = 1:length(clszAddVars)
                clszError{end+1} = ['     ' clszAddVars{v}];
            end % for v
        end
        
    elseif isa(matrix, 'function_handle')
        eszFormat = 'function_handle';
        NOT_YET_IMPLEMENTED();
    else
        clszError{end+1} = ['Ungültiges Format von Matrix ''' szMatrix '''!'];
    end

end % subfunction checkMatrix


function clszUsedVars = getAllUsedVars(stSys)

    clszUsedVars = {};
    clszFctFields = getSysStructFctFields();
    
    for f = 1:length(clszFctFields)
        szFct = clszFctFields{f};
        if ( isfield(stSys, szFct) && isa(stSys.(szFct), 'sym') )
            clszUsedVars = [clszUsedVars findsymcells(stSys.(szFct))];
        end
    end % for f
    
end % subfunction getAllUsedVars


function eszFormat = getFctFormat(stSys, szFct)

    if ~isfield(stSys, szFct)
        eszFormat = '';
    else
        fct = stSys.(szFct);

        if isa(fct, 'sym')
            eszFormat = 'sym';
        elseif isa(fct, 'function_handle')
            eszFormat = 'function_handle';
        elseif isnumeric(fct)
            eszFormat = 'numeric';
        else
            eszFormat = 'unknown';
        end

    end

end % subfunction getFctFormat
