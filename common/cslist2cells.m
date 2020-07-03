% function cslist2cells
%
%    Transforms a comma-seperated list in a cell array of strings
%    (The seperation character can be choosen.)
%
%    Syntax
%        C = cslist2cells(S [, szSep [, bTrim ] ] )
%
%    Arguments
%        S        String
%                Comma (or other value) seperated list
%        szSep    String {','}
%                Seperation character
%        bTrim    {true}, false
%                If TRUE, the list items are trimmed, i.e. all leading and
%                trailing whitespace characters are removed
%
%    Return values
%        C        Cell array of strings
%                List items
%
%    Example
%        S = 'abc, def   , ghijk';
%        C = cslist2cells(S)
%
%        [result:]   C = 'abc'    'def'    'ghijk'
%
%    see also CELLS2CSLIST
%

%    History
%        1.0.0    01.02.2013    EL
function C = cslist2cells(S, szSep, bTrim)

    if (nargin < 2), szSep = ','; end
    if (nargin < 3), bTrim = true; end

    
    C = {};
    uSepLen = length(szSep);

    if ~isempty(S)
        while true
            k = findstr(S, szSep);

            if isempty(k)
                if bTrim
                    C{end+1} = strtrim(S); %#ok<AGROW>
                else
                    C{end+1} = S; %#ok<AGROW>
                end
                
                break;
            else
                if bTrim
                    C{end+1} = strtrim( S(1:(k-1)) ); %#ok<AGROW>
                else
                    C{end+1} = S(1:(k-1)); %#ok<AGROW>
                end

                S = S(k+uSepLen:end);
            end
        end % while true
    end % isempty(S) ... else

end % function stringlist2cells
