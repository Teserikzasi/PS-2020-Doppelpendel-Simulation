function [szCexpr clszArgs szRet clszAuxVar] = sym2cexpr(symExpr, varargin)

	p = inputParser();
	p.KeepUnmatched = true;
	p.addOptional('Args', {}, @iscell);
	p.addParamValue('ArgVecLen', [], @isnumeric);
	p.addParamValue('WordWrap', false, @islogical);
	p.addParamValue('VecIDPrefix', '', @ischar);
	p.addParamValue('IdxStart', 1, @isnumeric);
	p.addParamValue('RetVarname', 'symExpr', @ischar);
	p.addParamValue('ScalarArgsBy', 'val', @ischar);
	p.addParamValue('StructArgsBy', 'ptr', @ischar);
	p.addParamValue('RetBy', 'ptr', @ischar);
	p.addParamValue('MatFormat', '[r][c]', @ischar);
	p.addParamValue('VecFormat', '[]', @ischar);
	p.addParamValue('Datatype', 'double', @ischar);
	p.parse(varargin{:});

	clArgs = p.Results.Args;
	vuVecLen = p.Results.ArgVecLen;
	szVecIDPrefix = p.Results.VecIDPrefix;
	bWordWrap = p.Results.WordWrap;
	szRetVarname = p.Results.RetVarname;
	szScalarArgsBy = p.Results.ScalarArgsBy;
	szStructArgsBy = p.Results.StructArgsBy;
	szRetBy = p.Results.RetBy;
	szMatFormat = p.Results.MatFormat;
	szVecFormat = p.Results.VecFormat;
	uSymIdxStart = p.Results.IdxStart;
	szDatatype = p.Results.Datatype;

	
	if isnumeric(symExpr)
		symExpr = sym(symExpr);
	end
    
	if ischar(symExpr)
		symExpr = sym(symExpr);
	end
	
	szCexpr = ccode(symExpr);
	
	% Bisweilen verlängert Matlab Variablennamen mit dem Zusatz "MLVar"
	% (Bisher bei der Variablen "D" festgestellt.)
	% Dies wird hiermit wieder rückgängig gemacht.
	% Der reguläre Ausdruck sucht nach
	%	einer beliebigen Anzahl an Zeichen, die entweder Buchstaben, Zahlen
	%	und Unterstriche sein können ([A-Za-z0-9_]*),
	%	auf die dann MLVar folgt (MLVar)
	%	und auf die KEIN Buchstabe, Zahl oder Unterstrich folgt
	%			( (?![A-Za-z0-9_]) )
	%	Dabei ist das auf MLVar folgende Zeichen NICHT Bestandteil des
	%	gesuchten Strings.
	% Dieser String wird durch das erste (und hier einzige) Token $1
	% ersetzt. Dieses wird durch die Klammern definiert, die den Teil vor
	% "MLVar" umfassen. (Das zweite Klammernpaar gehört zum
	% Look-Ahead_Operator (?=expr) und definiert kein Token.
	szCexpr = ...
		regexprep(szCexpr, '([A-Za-z0-9_]*)MLVar(?![A-Za-z0-9_])', '$1');
	
	vuResDim = size(symExpr);
	bResScalar = (all(vuResDim == 1));
	
	if bResScalar
		szCexpr = repvarstr(szCexpr, 't0', szRetVarname);
	else
		szCexpr = repvarstr(szCexpr, 'symExpr', szRetVarname);
	end
	
    
	if bWordWrap
	    szOldRowSep = ';';
		szNewLine = sprintf('\n');
		szNewRowSep = [';' szNewLine];
	
	    szCexpr = strrep(szCexpr, szOldRowSep, szNewRowSep);
	end
    
	
	if isempty(clArgs)
		clArgs = findsymcells(symExpr);
	end
	
	clclArgs = parseArgCells(clArgs, vuVecLen, szVecIDPrefix);

	stParams.eszScalarArgsBy = szScalarArgsBy;
	stParams.eszStructArgsBy = szStructArgsBy;
	stParams.eszVecFormat = szVecFormat;
	stParams.eszMatFormat = szMatFormat;
	stParams.szDatatype = szDatatype;
	stParams.bUseConstSpecifier = true;

	fctGetVar = @(a1, a2, a3) getRetVar_C(a1, a2, a3, stParams);

	[szCexpr clszArgs] = ...
				subsArgs(szCexpr, clclArgs, uSymIdxStart, fctGetVar);
	

	stParams.eszScalarArgsBy = szRetBy;
	stParams.eszVecFormat = szVecFormat;
	stParams.eszMatFormat = szMatFormat;
	stParams.szDatatype = szDatatype;
	stParams.bUseConstSpecifier = false;
	fctGetVar = @(a1, a2, a3) getRetVar_C(a1, a2, a3, stParams);

	if bResScalar
		szOldRes = szRetVarname;
		[szNewRes szRet] = fctGetVar(szRetVarname, [], []);
		szCexpr = repvarstr(szCexpr, szOldRes, szNewRes);

	else
		nR = vuResDim(1);
		nC = vuResDim(2);
		
		if (nR == 1)
			for c = 1:nC
				szOldRes = ...
					[ szRetVarname '[0][' num2str(c-1) ']' ];
				[szNewRes szRet] = fctGetVar(szRetVarname, c, nC);
				
				szCexpr = strrep(szCexpr, szOldRes, szNewRes);
			end % for c

		elseif (nC == 1)
			for r = 1:nR
				szOldRes = ...
					[ szRetVarname '[' num2str(r-1) '][0]' ];
				[szNewRes szRet] = fctGetVar(szRetVarname, r, nR);
				
				szCexpr = strrep(szCexpr, szOldRes, szNewRes);
			end % for r

		else
			for r = 1:nR
				for c = 1:nC
					szOldRes = ...
						[ szRetVarname '[' num2str(r-1) '][' ...
														num2str(c-1) ']' ];
					[szNewRes szRet] = ...
								fctGetVar(szRetVarname, [r c], [nR nC]);

					szCexpr = strrep(szCexpr, szOldRes, szNewRes);
				end % for c
			end % for r

		end
		
	end
	
	% Feststellen, ob von 'ccode' Hilfsvariablen eingeführt wurden
	szAuxVar = 'MapleGenVar1';
	iAux = 1;
	clszAuxVar = {};
	while ~isempty(findstr(szCexpr, szAuxVar))
		clszAuxVar{end+1} = szAuxVar; %#ok<AGROW>
		iAux = iAux + 1;
		szAuxVar = ['MapleGenVar' num2str(iAux)];
	end
       
end % function sym2cexpr
