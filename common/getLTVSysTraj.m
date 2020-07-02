function [A B C D] = getLTVSysTraj(stSysLin, stTraj, eszType)

    if (nargin < 3)
        eszType = 'fct';
    end
    
    %fct
    if strcmp(eszType, 'fct')
        [A B C D] = sys2fcts(stSysLin, 'GetLinSysMat', true, ...
                                            'TimeVarying', true, ...
                                            'LinPointDep', true, ...
                                            'NumIfPossible', true);
        A = getFctHandle(A, stTraj);
        B = getFctHandle(B, stTraj);
        C = getFctHandle(C, stTraj);
        D = getFctHandle(D, stTraj);
%     elseif strcmp(eszType, 'mat')
%         fA = getFctHandle(stSysLin.A, stTraj);
%         fB = getFctHandle(stSysLin.A, stTraj);
%         fC = getFctHandle(stSysLin.A, stTraj);
%         fD = getFctHandle(stSysLin.A, stTraj);
%         vT = stTraj.T;
%         for i = 1:length(vT)
%             A(i,:,:) = fA(vT(i));
%             B(i,:,:) = fB(vT(i));
%             C(i,:,:) = fC(vT(i));
%             D(i,:,:) = fD(vT(i));
%         end % for i
    else
        error('Unbekannter Wert für eszType');
    end
    
end % function


function At = getFctHandle(fct, stTraj)

    if isa(fct, 'function_handle')
        At = @(t) trajmat_wrap(t, fct, stTraj);
    else
        At = @(t) fct;
    end
    
end % subfunction getFctHandle
