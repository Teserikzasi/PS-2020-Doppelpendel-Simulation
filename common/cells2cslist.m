% function cells2cslist
%
%    Transforms a cell array of strings into a comma-seperated list
%    (The seperation character can be choosen.)
%
%    Syntax
%        S = cells2cslist(C [, szSep ] )
%
%    Arguments
%        C        Cell array of strings
%                List to be transformed
%        szSep    String {', '}
%                Seperation character
%                (If a space should appear after the seperation character,
%                it has to be included here! Therefore the standard value is
%                ', '.)
%
%    Return values
%        S        String
%                Comma-sperated list
%
%    Example
%        C = {'abc' 'def' 'ghijk'};
%        S = cells2cslist(C)
%
%        [result:]   S = 'abc, def, ghijk'
%
%    see also CSLIST2CELLS
%

%    History
%        1.0.0    01.02.2013    EL
function S = cells2cslist(C, szSep)

    if (nargin < 2), szSep = ', '; end

    S = '';

    for i=1:length(C)
        S = [S C{i} szSep]; %#ok<AGROW>
    end % for i

    if ~isempty(S)
        S = S(1:end-length(szSep));
    end

end % subfunction cell2cslist
