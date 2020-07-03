function S = repvarstr(S, szOld, szNew)

	S = regexprep(S, ['(?<!\w)' szOld '(?!\w)'], szNew);
	
end
