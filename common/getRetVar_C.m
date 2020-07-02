function [szResVar szResArg] = getRetVar_C(szVar, vElement, vRange, ...
																stParams)

	if stParams.bUseConstSpecifier
		szSpec = 'const ';
	else
		szSpec = '';
	end
		
	if isempty(vElement)
		if strcmp(stParams.eszScalarArgsBy, 'ptr')
			szResVar = [' *' szVar ' '];
			szResArg = [szSpec stParams.szDatatype '* const ' szVar];
		elseif strcmp(stParams.eszScalarArgsBy, 'ref')
			szResVar = szVar;
			szResArg = [szSpec stParams.szDatatype ' &' szVar];
		else
			szResVar = szVar;
			szResArg = [szSpec stParams.szDatatype ' ' szVar];
		end
		
	elseif isempty(vRange)
		if strcmp(stParams.eszStructArgsBy, 'ptr')
			szResVar = [' ' szVar '->' vElement ' '];
			szResArg = [szSpec 'CUSTOM_STRUCT * const ' szVar]; 
		elseif strcmp(stParams.eszStructArgsBy, 'ref')
			szResVar = [' ' szVar '.' vElement ' '];
			szResArg = [szSpec 'CUSTOM_STRUCT &' szVar]; 
		else
			szResVar = [' ' szVar '.' vElement ' '];
			szResArg = [szSpec 'CUSTOM_STRUCT ' szVar]; 
		end
		
	elseif (length(vElement) == 1)
		r = vElement(1);
		
		if strcmp(stParams.eszVecFormat, '[]')
			szResVar = [szVar '[' num2str(r-1) ']'];
			szResArg = [szSpec stParams.szDatatype ' ' szVar '[]'];
		else
			szResVar = [' *(' szVar '+' num2str(r-1) ') '];
			szResArg = [szSpec stParams.szDatatype '* const ' szVar];
		end
		
	else
		r = vElement(1);
		c = vElement(2);
		nR = vRange(1);
		nC = vRange(2);
		
		if strcmp(stParams.eszMatFormat, '[r][c]')
			szResVar = [szVar '[' num2str(r-1) '][' num2str(c-1) ']'];
			szResArg = [szSpec stParams.szDatatype ' ' szVar '[' num2str(nR) ...
													'][' num2str(nC) ']'];
			
		elseif strcmp(stParams.eszMatFormat, '[c][r]')
			szResVar = [szVar '[' num2str(c-1) '][' num2str(r-1) ']'];
			szResArg = [szSpec stParams.szDatatype ' ' szVar '[' num2str(nC) ...
													'][' num2str(nR) ']'];
			
		elseif strcmp(stParams.eszMatFormat, '**')
			error('Option ''**'' noch nicht implementiert!');
			
		elseif strcmp(stParams.eszMatFormat, '*_colbycol')
			szResVar = [' *(' szVar '+' num2str(r-1) '+' num2str(c-1) '*' num2str(nR) ') '];
			szResArg = [szSpec stParams.szDatatype '* const ' szVar];
			
		elseif strcmp(stParams.eszMatFormat, '*_rowbyrow')
			szResVar = [' *(' szVar '+' num2str(c-1) '+' num2str(r-1) '*' num2str(nC) ') '];
			szResArg = [szSpec stParams.szDatatype '* const ' szVar];
		end
	end

end % function getResVar_C
