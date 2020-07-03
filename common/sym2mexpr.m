function [szMexpr clszArgs] = sym2mexpr(symExpr, varargin)

	p = inputParser();
	p.KeepUnmatched = true;
	p.addOptional('Args', {}, @iscell);
	p.addParamValue('ArgVecLen', [], @isnumeric);
	p.addParamValue('Digits', -1, @isnumeric);
	p.addParamValue('WordWrap', false, @islogical);
	p.addParamValue('VecIDPrefix', '', @ischar);
	p.addParamValue('IdxStart', 1, @isnumeric);
	p.addParamValue('VectorizeOps', false, @islogical);
	
	p.parse(varargin{:});

	clArgs = p.Results.Args;
	vuVecLen = p.Results.ArgVecLen;
	szVecIDPrefix = p.Results.VecIDPrefix;
	bWordWrap = p.Results.WordWrap;
	nDigits = p.Results.Digits;
	uSymIdxStart = p.Results.IdxStart;
	bVectorizeOps = p.Results.VectorizeOps;

	
	if isnumeric(symExpr)
		symExpr = sym(symExpr);
	end
	
	
	if (nDigits == -1)
		szMexpr = char(symExpr);
	else
		if (nDigits == 0)
			nDigits = digits();
		end

		szMexpr = char(vpa(symExpr, nDigits));
	end
	
	if (bVectorizeOps)
		szMexpr = regexprep(szMexpr, '([*/^])', '.$0');
	end
    
    % aus irgendeinem Grund erzeugt char() machmal aus 'conj()' die Funtion
    % conjugate(), die Matlab nicht kennt. Daher:
    szMexpr = strrep(szMexpr, 'conjugate', 'conj');

	
	if (length(szMexpr) > 8)
        if strcmp( szMexpr(1:7), 'vector(' )
			szMexpr = szMexpr(8:length(szMexpr)-1);
        elseif strcmp( szMexpr(1:8), 'matrix([' )
			szMexpr = szMexpr(9:length(szMexpr)-2);
        end
	end
    
	
	if ~isempty(findstr(szMexpr, '],['))
		szOldRowSep = '],[';
	elseif ~isempty(findstr(szMexpr, '], ['))
		szOldRowSep = '], [';
	else
		szOldRowSep = [];
	end
		
	if ~isempty(szOldRowSep)
		if bWordWrap
			szNewLine = sprintf('\n');
			szNewRowSep = ['; ...' szNewLine];
		else
			szNewRowSep = '; ';
		end
	
        szMexpr = strrep(szMexpr, szOldRowSep, szNewRowSep);
	end
	
	szMexpr = strrep(szMexpr, ',', ', ');
	
	if isempty(clArgs)
		clArgs = findsymcells(symExpr);
	end
	
	clclArgs = parseArgCells(clArgs, vuVecLen, szVecIDPrefix);
		
	[szMexpr clszArgs] = subsArgs(szMexpr, clclArgs, uSymIdxStart, ...
														@getRetVar_Matlab);

end % function sym2mexpr
