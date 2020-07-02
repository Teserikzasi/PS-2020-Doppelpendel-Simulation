function [szResVar szResArg] = getResVar_Matlab(szVar, vElement, vRange)

	if isempty(vElement)
		szResVar = szVar;
		szResArg = szVar;
		
	elseif isempty(vRange)
		szResVar = [szVar '.' vElement];
		szResArg = szVar;
		
	elseif (length(vElement) == 1)
		r = vElement(1);
		szResVar = [szVar '(' num2str(r) ')'];
		szResArg = szVar;
		
	else
		r = vElement(1);
		c = vElement(2);
		
		szResVar = [szVar '(' num2str(r) ',' num2str(c) ')'];
		szResArg = szVar;
	end

end % function getResVar_Matlab
