function [A B C D] = sys2ltimat(stSysLin)

    [A B C D] = ...
        sys2fcts(stSysLin, 'GetLinSysMat', true, 'NumIfPossible', true);

end % function sys2ltimat
