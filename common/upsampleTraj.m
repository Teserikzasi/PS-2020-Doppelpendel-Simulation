function stTraj = upsampleTraj(stTraj, n, eszMethod)

    if (nargin < 3), eszMethod = 'spline'; end
    
    
    if ~isfield(stTraj, 'T')
        error('Fehler: Ungültige Struktur für stTraj!');
    end
    
    
    vTold = stTraj.T.data;
    nTold = length(vTold);
    
    vID = (0:nTold-1)';
    vIDnew = (0:(nTold-1)*n)' / n;
    
    vTnew = interp1(vID, vTold, vIDnew, 'linear');
    
    stTraj.T.data = vTnew;
    
    

    clszFields = fieldnames(stTraj);
    clszFields = setdiff(clszFields, 'T');
    
    for s = 1:length(clszFields)
        szF = clszFields{s};
        if ~isfield(stTraj.(szF), 'data')
            continue;
        end
        
        stTraj.(szF).data = interp1(vTold, stTraj.(szF).data, vTnew, eszMethod);
    end % for s

end % function
