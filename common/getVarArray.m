function clszVars = getVarArray(szPrefix, nVars)

    if (nVars == 0)
        clszVars = {szPrefix};
    else
        clszVars = cell(1, nVars);

        for i = 1:nVars
            clszVars{i} = [szPrefix num2str(i)];
        end % for i
    end
    
end % function getVarArray
