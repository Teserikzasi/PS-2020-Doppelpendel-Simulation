% function C = findsymcells(symexpr)
%
%    Returns the names of the symbolic variables of an symbolic expression
%    as a cell array.
%
%    Syntax
%        C = findsymcells(symexpr)
%
%    Arguments
%        symexpr        sym
%                    symbolic expression
%
%    Return values
%        C            Cell array of string
%                    Names of symbolic variables apprearing in symexpr
%
%    Example
%        C = findsymcells( sym('x + 3 * a') )
%
%        [result:]   C = 'a'   'x'
%
%    see also sym/findsym
%

%    History
%        1.0.0    01.02.2013    EL
function clszSymVariables = findsymcells(symexpr)

    if isnumeric(symexpr)
        clszSymVariables = {};
        return;
    end
    
    svars = symvar(symexpr);
    
    clszSymVariables = arrayfun(@(x) char(x), svars, ...
                                'UniformOutput', false);

end % function findsymcells
