function [fctF fctH stSysInfo] = getSysFcts(stSys, bTV, eszParameterDep)

    fctF = [];
    fctH = [];
    
    if strcmp(eszParameterDep, 'vec')
        stSys = standardizeSys(stSys, 'StdParam', true);
    else
        stSys = standardizeSys(stSys, 'StdParam', false);
    end
    
    [bOk stSysInfo] = checkSys(stSys);
    
    if (bTV)
        clszArgs = {'x' 'u' 't'};
        szArgs = 'x, u, t, ';
        vArgVecLen = [stSysInfo.nStates, stSysInfo.nInputs, 0];
    else
        clszArgs = {'x' 'u'};
        szArgs = 'x, u, ';
        vArgVecLen = [stSysInfo.nStates, stSysInfo.nInputs];
    end
    
    if ( (stSysInfo.nParams ~= 0) && strcmp(eszParameterDep, 'none') )
        error('Das System verfügt über Parameter!');
    end

    if strcmp(eszParameterDep, 'vec')
        clszArgs{end+1} = 'p';
        szArgs = [szArgs 'p, '];
        vArgVecLen = [vArgVecLen stSysInfo.nParams];
    elseif strcmp(eszParameterDep, 'struct')
        clszArgs{end+1} = {'p' cslist2cells(stSysInfo.szPNames)};
        szArgs = [szArgs 'p, '];
        vArgVecLen = [vArgVecLen 0];
    elseif strcmp(eszParameterDep, 'arglist')
        clszArgs = [clszArgs cslist2cells(stSysInfo.szPNames)];
        szArgs = [szArgs stSysInfo.szPNames ', '];
        vArgVecLen = [vArgVecLen zeros(1, stSysInfo.nParams)];
    end
    
    if ~isempty(szArgs)
        szArgs = szArgs(1:end-2);
    end

    
    if ( stSysInfo.bLinear )
        
        if ( strcmp(stSysInfo.eszFormat, 'numeric') || ...
                strcmp(stSysInfo.eszFormat, 'sym') )

            svX = getSymVector('x', stSysInfo.nStates);
            svU = getSymVector('u', stSysInfo.nInputs);
    
            fctF = [];
            if (stSysInfo.bInputAffine)
                if ( isa(stSys.A, 'sym') || isa(stSys.B, 'sym') )
                    seF = sym(stSys.A) * svX + sym(stSys.B) * svU;
                else
                    fctF = eval(['@(' szArgs ') stSys.A * x + stSys.B * u']);
                end
            else
                if isa(stSys.A, 'sym')
                    seF = sym(stSys.A) * svX;
                else
                    fctF = eval(['@(' szArgs ') stSys.A * x']);
                end
            end        
            if isempty(fctF)
                fctF = sym2fct(seF, 'Args', clszArgs, ...
                                    'ArgVecLen', vArgVecLen);
            end

            fctH = [];
            if (stSysInfo.nOutputs > 0)

                if (stSysInfo.bDirectFeedthrough)
                    if ( isa(stSys.C, 'sym') || isa(stSys.D, 'sym') )
                        seH = sym(stSys.C) * svX + sym(stSys.D) * svU;
                    else
                        fctH = eval(['@(' szArgs ') stSys.C * x + stSys.D * u']);
                    end
                else
                    if isa(stSys.C, 'sym')
                        seH = sym(stSys.C) * svX;
                    else
                        fctH = eval(['@(' szArgs ') stSys.C * x']);
                    end
                end

                if isempty(fctH)
                    fctH = sym2fct(seH, 'Args', clszArgs, ...
                                        'ArgVecLen', vArgVecLen);
                end
            end

        else
            NOT_YET_IMPLEMENTED();
        end

    else
        if strcmp(stSysInfo.eszFormat, 'sym')
            
            if (stSysInfo.bInputAffine)
                svU = getSymVector('u', stSysInfo.nInputs);
                % TODO: Prüfen, ob eine der Variablen schon vorkommt
                
                stSys.f = stSys.f + stSys.g * svU;
            end
                        
            fctF = sym2fct(stSys.f, 'Args', clszArgs, ...
                                    'ArgVecLen', vArgVecLen);
            
            if (stSysInfo.bOutputEq)
                fctH = sym2fct(stSys.h, 'Args', clszArgs, ...
                                    'ArgVecLen', vArgVecLen);
            end
        elseif strcmp(stSysInfo.esz, 'function_handles')
            NOT_YET_IMPLEMENTED;
        end
    end
    
end % function getGeneralNLTVFcts
