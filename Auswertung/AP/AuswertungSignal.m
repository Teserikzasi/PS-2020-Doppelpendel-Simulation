function results = AuswertungSignal(x,in)
% Wertet den Verlauf einer einzelnen Größe aus (um 0 zentriert)
% in: Einschwinggrenze

    results.max = max(abs(x));
    results.xend = x(end);
    results.J = sum(x.^2);
    
    results.in = 1;
    for i=length(x):-1:1 
        if abs(x(i))>in
            results.in = i;
            break;
        end
    end
    
end