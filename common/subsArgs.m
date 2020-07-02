function [szExpr clszArgs] = subsArgs(szExpr, clclArgs, uSymIdxStart, ...
															fctGetRetVar)

	nArgs = length(clclArgs);
	
	clszArgs = cell(1, nArgs);

	for a = 1:nArgs
		clArg = clclArgs{a};
		
		szSymArg = clArg{1};
		
		idAlias = strfind(szSymArg, '=>');
		
		if isempty(idAlias)
			szRetArg = szSymArg;
		else
			szRetArg = szSymArg(idAlias+2:end);
			szSymArg = szSymArg(1:idAlias-1);
		end

		nArgOpts = length(clArg) - 1;

		
		bInvalidArg = false;
		
		% Skalar ?
		if (nArgOpts == 0)
			[szRetVar clszArgs{a}] = fctGetRetVar(szRetArg, [], []);
			szExpr = repvarstr(szExpr, szSymArg, szRetVar);

		% Vektor (Elementindex)
		elseif ( (nArgOpts == 1) && isnumeric(clArg{2}) ) 
			
			nR = clArg{2};
			
			for r = 1:nR
				if (r == 1)
					[szRetVar clszArgs{a}] = fctGetRetVar(szRetArg, r, nR);
				else
					szRetVar = fctGetRetVar(szRetArg, r, nR);
				end
				
				szSymVar = [szSymArg num2str(r-1+uSymIdxStart)];
				
				szExpr = repvarstr(szExpr, szSymVar, szRetVar);
			end % for e
			
		% Vektor (Elementnamen)
		elseif ( (nArgOpts == 1) && iscell(clArg{2}) )
			nE = length(clArg{2});
			
			for e = 1:nE
				szSymVar = clArg{2}{e};
								
				if (e == 1)
					[szRetVar clszArgs{a}] = fctGetRetVar(szRetArg, e, nE);
				else
					szRetVar = fctGetRetVar(szRetArg, e, nE);
				end
				
				szExpr = repvarstr(szExpr, szSymVar, szRetVar);
			end % for e
		
		% Matrix
		elseif ( ( (nArgOpts == 2) && ...
						isnumeric(clArg{2}) && isnumeric(clArg{3}) ) ...
					|| ...
				( (nArgOpts == 3) &&  ...
						isnumeric(clArg{2}) && ischar(clArg{3}) && ...
							isnumeric(clArg{4}) ) )
		
			nR = clArg{2};
			
			if (nArgOpts == 2)
				szSep = '';
				nC = clArg{3};
			else
				szSep = clArg{3};
				nC = clArg{4};
			end

			for r = 1:nR
				for c = 1:nC
					szSymVar = [szSymArg num2str(r-1+uSymIdxStart) ...
										szSep num2str(c-1+uSymIdxStart)];
									
					if ((r == 1) && (c == 1))
						[szRetVar clszArgs{a}] = ...
									fctGetRetVar(szRetArg, [r c], [nR nC]);
					else
						szRetVar = fctGetRetVar(szRetArg, [r c], [nR nC]);
					end

					szExpr = repvarstr(szExpr, szSymVar, szRetVar);
					
				end % for c
			end % for r
			
		% Struktur
		elseif ( (nArgOpts == 2) ...
						&& iscell(clArg{2}) ...
						&& ischar(clArg{3}) && strcmp(clArg{3}, 'struct') )
		
			for e = 1:length(clArg{2})
				szSymVar = clArg{2}{e};
				
				idAlias = strfind(szSymVar, '=>');

				if isempty(idAlias)
					szRetVar = szSymVar;
				else
					szRetVar = szSymVar(idAlias+2:end);
					szSymVar = szSymVar(1:idAlias-1);
				end
				
				if (e == 1)
					[szRetVar clszArgs{a}] = ...
									fctGetRetVar(szRetArg, szRetVar, []);
				else
					szRetVar = fctGetRetVar(szRetArg, szSymVar, []);
				end
				
				szExpr = repvarstr(szExpr, szSymVar, szRetVar);
			end % for e
		end

		if bInvalidArg
			error('Ungültige Argumentoptionen!');
		end

	end % for a
	
	vstTmpNames = [];
	
	for a = 1:length(vstTmpNames)
		szExpr = repstr(szExpr, vstTmpNames(a).tmp, vstTmpNames(a).new);
	end % for a

end % function subsArgs
