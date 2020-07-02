function mRes = runFctOnTraj(stTraj, fctStatement, clszArgs)

    nT = length(stTraj.T.data);
    
    clArgVals = getArgVals(clszArgs, stTraj, 1);
    
    res = fctStatement(clArgVals{:});
    
    [rRes cRes] = size(res);
    
    mRes = zeros(nT, rRes, cRes);
    mRes(1,:,:) = res;
    
    for it = 2:nT
        clArgVals = getArgVals(clszArgs, stTraj, it);
        res = fctStatement(clArgVals{:});
        mRes(it,:,:) = res;
    end

end % function


function clArgVals = getArgVals(clszArgs, stTraj, id)

    clArgVals = cell(1, length(clszArgs));
    
    for a = 1:length(clszArgs)
        clArgVals{a} = shiftdim(stTraj.(clszArgs{a}).data(id,:,:), 1);
    end % for a
    
end % subfunction getArgVals
    