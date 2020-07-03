function fct = sym2fct(symexpr, varargin)

	p = inputParser();
	p.KeepUnmatched = true;
	p.addOptional('Args', {}, @iscell);
	p.addParamValue('CreateAnonymousFct', true, @islogical);
	p.parse(varargin{:});
	
	clArgs = p.Results.Args;
	bAnonymousFct = p.Results.CreateAnonymousFct;
	
 	if isempty(clArgs)
 		clArgs = findsymcells(symexpr);
	end

	if ( ~isempty(varargin) && iscell(varargin{1}) )
		varargin = varargin(2:end);
	end
	
	
	[szSymexpr clszArgs] = sym2mexpr(symexpr, clArgs, varargin{:});

	for a = 1:length(clszArgs)
		szCurArg = clszArgs{a};
		
		if (a == 1)
			szArgs = ['''' szCurArg ''''];
		else
			szArgs = [szArgs ', ''' szCurArg '''']; %#ok<AGROW>
		end
	end	
	
	
	if ~bAnonymousFct
		fct = eval(['inline(''' szSymexpr ''', ' szArgs ')']);
	else
		% Variante mit anonymen Funktionen
	 	szArgs = strrep(szArgs, '''', '');
	 	szCmd = ['fct = @(' szArgs ') ' szSymexpr ';'];
	 	eval(szCmd);
	end
	
end % function sym2fct
