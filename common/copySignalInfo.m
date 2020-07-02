function stTargetSig = copySignalInfo(stTargetSig, stSourceSig)

    clszInfoFields = {'name' 'desc' 'unit'};
    
    for f = 1:length(clszInfoFields)
        szField = clszInfoFields{f};
        if isfield(stSourceSig, szField)
            stTargetSig.(szField) = stSourceSig.(szField);
        end
    end % for f
    
end % function copySignalInfo
