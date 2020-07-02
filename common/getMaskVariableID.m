function id = getMaskVariableID(szMaskVariables, szVar)

    idStart = findstr(szMaskVariables, [';' szVar '=']);
    
    if isempty(idStart)
        if strcmp( szMaskVariables(1:length(szVar)+1), [szVar '='] )
            idStart = 1;
        else
            id = [];
        end
    else
        idStart = idStart + 1;
    end
    
    if ~isempty(idStart)
        idCurChar = idStart + length(szVar) + 2;
        szCurChar = szMaskVariables(idCurChar);

        szID = [];
        
        while (szCurChar ~= ';')
            szID = [szID szCurChar];
            idCurChar = idCurChar + 1;
            szCurChar = szMaskVariables(idCurChar);
        end
        
        id = str2double(szID);
    end

end % getMaskVariableID