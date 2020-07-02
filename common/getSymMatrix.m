function M = getSymMatrix(nR, nC, szPrefix, szSep, eszSpec)
    
    if (nargin < 3), szPrefix = 'm'; end
    if (nargin < 4), szSep = ''; end
    if (nargin < 5), eszSpec = ''; end
    
    bR = ~(isempty(nR) || (nR == 0));
    bC = ~(isempty(nC) || (nC == 0));
    
    if (~bR)
        nR = 1;
    end
    
    if (~bC)
        nC = 1;
    end
    
    M = sym(zeros(nR,nC));

    for r = 1:nR
        for c = 1:nC
            if (~bR)
                szV = [ szPrefix num2str(c) ];
            elseif (~bC)
                szV = [ szPrefix num2str(r) ];
            else
                szV = [ szPrefix num2str(r) szSep num2str(c) ];
            end
            
            if isempty(eszSpec)
                M(r,c) = sym(szV);
            else
                M(r,c) = sym(szV, eszSpec);
            end
        end % for c
    end % for r

end % function getSymMatrix
