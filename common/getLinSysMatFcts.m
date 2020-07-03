function [fctA fctB fctC fctD stSysInfo] = getLinSysMatFcts(stSys, ...
                                                    bLinPointDep, ...
                                                    bTV, ...
                                                    eszParameterDep, ...
                                                    bNumIfPossible)


    if strcmp(eszParameterDep, 'vec')
        stSys = standardizeSys(stSys, 'StdParam', true);
    else
        stSys = standardizeSys(stSys, 'StdParam', false);
    end
    
    [bOk stSysInfo] = checkSys(stSys);

    if ( ~stSysInfo.bLinear )
        error('System muss linear sein!');
        %return;
    end


    
    if ( (stSysInfo.nParams ~= 0) && strcmp(eszParameterDep, 'none') )
        error('Das System verfügt über Parameter!');
    end

    if ( (stSysInfo.bTimeVarying) && ~bTV )
        error('Das System ist zeitvariant!');
    end
    
    if ( stSysInfo.bLinPointDependent && ~bLinPointDep )
        error('Das System ist von x0 und/oder u0 abhängig!');
    end
    
    clszArgs = {};
    szArgs = '';
    vuArgVecLen = [];
    
    if bLinPointDep
        clszArgs{end+1} = 'x0';
        clszArgs{end+1} = 'u0';
        szArgs = [szArgs 'x0, u0, '];
        vuArgVecLen = [vuArgVecLen stSysInfo.nStates stSysInfo.nInputs];
    end

    if bTV
        clszArgs{end+1} = 't';
        szArgs = [szArgs 't, '];
        vuArgVecLen = [vuArgVecLen 0];
    end

    if strcmp(eszParameterDep, 'vec')
        clszArgs{end+1} = 'p';
        szArgs = [szArgs 'p, '];
        vuArgVecLen = [vuArgVecLen stSysInfo.nParams];
    elseif strcmp(eszParameterDep, 'struct')
        clszArgs{end+1} = {'p' cslist2cells(stSysInfo.szPNames)};
        szArgs = [szArgs 'p, '];
        vuArgVecLen = [vuArgVecLen 0];
    elseif strcmp(eszParameterDep, 'arglist')
        clszArgs = [clszArgs cslist2cells(stSysInfo.szPNames)];
        szArgs = [szArgs stSysInfo.szPNames ', '];
        vuArgVecLen = [vuArgVecLen zeros(1, stSysInfo.nParams)];
    end
    
    if ~isempty(szArgs)
        szArgs = szArgs(1:end-2);
    end

    if ( strcmp(stSysInfo.eszFormat, 'numeric') || ...
            strcmp(stSysInfo.eszFormat, 'sym') )

        fctA = getMatFct(stSys.A, bNumIfPossible, ...
                                    clszArgs, vuArgVecLen, szArgs, ...
                                    [stSysInfo.nStates stSysInfo.nStates]);

        if ~isfield(stSys, 'B')
            stSys.B = [];
        end
        fctB = getMatFct(stSys.B, bNumIfPossible, ...
                                    clszArgs, vuArgVecLen, szArgs, ...
                                    [stSysInfo.nStates stSysInfo.nInputs]);
        
        if ~isfield(stSys, 'C')
            stSys.C = [];
        end
        fctC = getMatFct(stSys.C, bNumIfPossible, ...
                                    clszArgs, vuArgVecLen, szArgs, ...
                                    [stSysInfo.nOutputs stSysInfo.nStates]);

        if ~isfield(stSys, 'D')
            stSys.D = [];
        end
        fctD = getMatFct(stSys.D, bNumIfPossible, ...
                                    clszArgs, vuArgVecLen, szArgs, ...
                                    [stSysInfo.nOutputs stSysInfo.nInputs]);
    else
        NOT_YET_IMPLEMENTED();
    end    
    
end % function getLinFcts


function fctM = getMatFct(M, bNumIfPossible, ...
                                    clszArgs, vuArgVecLen, szArgs, vuDim)

    if isempty(M)
        M = zeros(vuDim);
    end
        
    if (isa(M, 'sym'))
        if (isempty(symvar(M)) && bNumIfPossible)
            fctM = double(M);
        else
            fctM = sym2fct(M, 'Args', clszArgs, ...
                                            'ArgVecLen', vuArgVecLen);
        end
        
    elseif (isnumeric(M))
        if bNumIfPossible
            fctM = M;
        else
            fctM = eval(['@(' szArgs ') M']);
        end
        
    else
        NOT_YET_IMPLEMENTED();
    end

end % function getMatFct
