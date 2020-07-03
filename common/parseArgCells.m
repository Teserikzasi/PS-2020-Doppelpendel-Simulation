function clclArgs = parseArgCells(clszArgs, vuArgVecLen, szPrefix)

	nArgs = length(clszArgs);
	
	if ( ~isempty(vuArgVecLen) && (length(vuArgVecLen) ~= nArgs) )
		error('vuArgVecLen muss, wenn angegeben, soviel Elemente wie clszArgs besitzen!');
	end
	
	clclArgs = cell(1, nArgs);
	
	for a = 1:nArgs
		if ischar(clszArgs{a})
			szArg = clszArgs{a};
			
			if ~isempty(vuArgVecLen)
				uLen = vuArgVecLen(a);
			else
				uLen = 0;
			end
			
			if (uLen == 0)
				clclArgs{a} = {szArg};
			else
				if isempty(szPrefix)
					clclArgs{a} = {szArg uLen};
				else
					clclArgs{a} = {[szArg szPrefix '=>' szArg] uLen};
				end
			end
				
		elseif iscell(clszArgs)
			clclArgs{a} = clszArgs{a};
			
		else
			error('Ungültiger Eintrag in Args!');
		end
	end % for a
	
end % function parseArgCells
