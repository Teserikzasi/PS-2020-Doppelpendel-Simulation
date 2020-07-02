function szSysInfo = getSysInfoString(stSysInfo)


    clszInfo = {};
    
    clszInfo{end+1} = ['Name        : ' stSysInfo.name];
    clszInfo{end+1} = ['Description : ' stSysInfo.desc];
    clszInfo{end+1} = ' ';
    clszInfo{end+1} = ['System type : ' stSysInfo.szType];
    clszInfo{end+1} = ['State eq.   : ' stSysInfo.szStateEqType];
    clszInfo{end+1} = ['Output eq.  : ' stSysInfo.szOutputEqType];
    clszInfo{end+1} = ' ';
    clszInfo{end+1} = ['Nb. Inputs  : ' num2str(stSysInfo.nInputs)];
    clszInfo{end+1} = ['Nb. States  : ' num2str(stSysInfo.nStates)];
    clszInfo{end+1} = ['Nb. Outputs : ' num2str(stSysInfo.nOutputs)];
    clszInfo{end+1} = ' ';
    
    clszInfo{end+1} = ['    u = [ ' stSysInfo.szUNames ' ]'''];
    
    if ~isempty(stSysInfo.szUUnits)
        clszInfo{end+1} = ['     [u] = ' stSysInfo.szUUnits];
    end
    
    clszInfo{end+1} = ['    x = [ ' stSysInfo.szXNames ' ]'''];
    
    if ~isempty(stSysInfo.szXUnits)
        clszInfo{end+1} = ['     [x] = ' stSysInfo.szXUnits];
    end
    
    if ~isempty(stSysInfo.szYNames)
        clszInfo{end+1} = ['    y = [ ' stSysInfo.szYNames ' ]'''];
        
        if ~isempty(stSysInfo.szYUnits)
            clszInfo{end+1} = ['     [y] = ' stSysInfo.szYUnits];
        end
    end
    if ~isempty(stSysInfo.szTNames)
        if isempty(stSysInfo.szTUnits)
            clszInfo{end+1} = ['    t = ' stSysInfo.szTNames];
        else
            clszInfo{end+1} = ['    t = ' stSysInfo.szTNames ',   [t] = ' stSysInfo.szTUnits];
        end
    end
    clszInfo{end+1} = ' ';
    clszInfo{end+1} = ['Nb. Params  : ' num2str(stSysInfo.nParams)];
    clszInfo{end+1} = ' ';
    if ~isempty(stSysInfo.szPNames)
        if isempty(stSysInfo.szPUnits)
            clszInfo{end+1} = ['    p = [ ' stSysInfo.szPNames ' ]'''];
        else
            clszInfo{end+1} = ['    p = [ ' stSysInfo.szPNames ' ]'',   [p] = ' stSysInfo.szPUnits];
        end
    end
    clszInfo{end+1} = ' ';
    
    szSysInfo = char(clszInfo);
    
end % function getSysDescString

