function C = each_in(C)

    if isempty(C)
        C = [];
    end
    
    if ( isvector(C) && (size(C, 1) > 1) )
        C = C.';
    end

end % function each_in
