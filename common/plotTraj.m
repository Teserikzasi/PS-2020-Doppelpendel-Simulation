function plotTraj(clstTrajs, clszFields, clvIDs)

    if ~iscell(clstTrajs)
        clstTrajs = {clstTrajs};
    end
    
    % Wenn keine Felder gewählt, dann Standardfelder Y und U
    if (nargin < 2)
        clszFields = {'Y' 'U'};
    else
        if ischar(clszFields)
            clszFields = {clszFields};
        end
    end
    
    % Wenn keine Elemente gewählt, dann für jedes Feld alle Elemente
    % auswählen
    if (nargin < 3)
        for i = 1:length(clszFields)
            clvIDs{i} = -1;
        end % for i
    else
        if isnumeric(clvIDs)
            clvIDs = {clvIDs};
        end
    end
    
    nPlots = 0;
    f = 0;
    while(f < length(clszFields))
        f = f + 1;
        if ~isfield(clstTrajs{1}, clszFields{f})
            disp([clszFields{f} ' ist in stTraj nicht vorhanden!']);
            clszFields(f) = [];
            f = f-1;
            continue;
        end
        
        if ( isnumeric(clvIDs{f}) && ...
                    ( (length(clvIDs{f}) == 1) && (clvIDs{f} == -1) ) )
            nR = size(clstTrajs{1}.(clszFields{f}).data, 2);
            nC = size(clstTrajs{1}.(clszFields{f}).data, 3);

            clvIDs{f} = 1:(nR*nC);
            
        elseif iscell(clvIDs{f})
            nR = size(clstTrajs{1}.(clszFields{f}).data, 2);
            nC = size(clstTrajs{1}.(clszFields{f}).data, 3);

            vRIDs = clvIDs{f}{1};
            vCIDs = clvIDs{f}{2};
            
            if ( (length(vRIDs) == 1) && (vRIDs == -1) )
                vRIDs = 1:nR;
            end
            if ( (length(vCIDs) == 1) && (vCIDs == -1) )
                vCIDs = 1:nC;
            end
            
            % vRIDs muss liegender Vektor sein
            vRIDs = reshape(vRIDs, 1, length(vRIDs));
            
            vIDs = [];
            for ic = 1:length(vCIDs)
                c = vCIDs(ic);
                vIDs = [vIDs, vRIDs+(c-1)*nR];
            end % for ic
            
            clvIDs{f} = vIDs;
        end
        nPlots = nPlots + length(clvIDs{f});
    end % while (f < length(clszFields))

    szXLabel = getLabel(clstTrajs{1}.T);
    if isempty(szXLabel)
        szXLabel = 't';
    end
    
    % Aufteilung Subplots festlegen
    if ( length(clszFields) == 1 )
        nR = size(clstTrajs{1}.(clszFields{1}).data, 2);
        nC = size(clstTrajs{1}.(clszFields{1}).data, 3);
        
        if ( (nR > 1) && (nC > 1) )
            vIDs = clvIDs{1};
            
            % Feststellen, ob in allen Spalten die gleichen Zeilen
            % ausgewählt
            
            vCPlot = ceil(vIDs/nR);
            vRPlot = mod( vIDs-1, nR) + 1;
            
            vCPlotunique = unique(vCPlot);
            vRPlotunique = unique(vRPlot);
            
            vR_Ref = vRPlot(vCPlot == vCPlotunique(1));
            bFailed = false;
            
            for ic = 2:length(vCPlotunique)
                vR_ic = vRPlot(vCPlot == vCPlotunique(ic));
                
                if ( (length(vR_Ref) ~= length(vR_ic)) || ...
                                                any(vR_Ref ~= vR_ic) )
                    bFailed = true;
                    break;
                end
            end % for ic
            
            if ~bFailed
                nPlotsR = length(vRPlotunique);
                nPlotsC = length(vCPlotunique);
            else
                nPlotsR = nPlots;
                nPlotsC = 1;
            end

        else
            nPlotsR = nPlots;
            nPlotsC = 1;
        end
    else
        nPlotsR = nPlots;
        nPlotsC = 1;
    end
    

    figure();
    vhAxes = zeros(nPlots, 1);
    iP = 0;
    % Schleife über alle zu plottenden Felder
    for f = 1:length(clszFields)
        szField = clszFields{f};
        
        % Schleife über alle vom aktuellen Feld zu plottenden Einträge
        for k = 1:length(clvIDs{f})
            j = clvIDs{f}(k);
            iP = iP + 1;
            
            % Umrechnen iP von spalten- auf zeilenweise Zählung
            iRs = mod( iP-1, nPlotsR) + 1;
            iCs = ceil( iP/nPlotsR );
            iPs = iCs + (iRs-1) * nPlotsC;
            
            vhAxes(iP) = subplot(nPlotsR, nPlotsC, iPs);
            
            nR = size(clstTrajs{1}.(clszFields{f}).data, 2);
            nC = size(clstTrajs{1}.(clszFields{f}).data, 3);
            
            if (nC > 1)
                r = mod( j-1, nR) + 1;
                c = ceil(j/nR);
            else
                r = j;
                c = 1;
            end
            
            for tr = 1:length(clstTrajs)
                vTcur = clstTrajs{tr}.T.data;
                vXcur = clstTrajs{tr}.(szField).data(:,r,c);
                
                if isfield(clstTrajs{tr}.(szField), 'initdata')
                    tspan = vTcur(end)-vTcur(1);
                    vTcur = [vTcur(1)-0.01*tspan; vTcur(1); vTcur];
                    vXcur = [clstTrajs{tr}.(szField).initdata(r,c); ...
                                clstTrajs{tr}.(szField).initdata(r,c); ...
                                vXcur];
                end
                
                if isfield(clstTrajs{tr}.(szField), 'enddata')
                    tspan = vTcur(end)-vTcur(1);
                    vTcur = [vTcur; vTcur(end); vTcur(end)+0.01*tspan];
                    vXcur = [vXcur; ...
                                clstTrajs{tr}.(szField).enddata(r,c); ...
                                clstTrajs{tr}.(szField).enddata(r,c)];
                end
                
                plot(vTcur, vXcur);
                hold('all');
            end
            hold('off');
            
            szYLabel = getLabel(clstTrajs{1}.(szField), j);

            if (nC > 1)
                szTitle = [szField '(' num2str(r) ',' num2str(c) ')'];
            else
                szTitle = [szField '(' num2str(j) ')'];
            end
            
            if isempty(szYLabel)
                szYLabel = szTitle;
            else
                szTitle = [ szTitle ' : ' szYLabel ];
            end
            title(szTitle, 'Interpreter', 'none');
            ylabel(szYLabel, 'Interpreter', 'none');
        end % for j
        
        if (f == length(clszFields))
            bPrintLegend = false;
            for tr = 1:length(clstTrajs)
                if isfield(clstTrajs{tr}, 'name')
                    clszLegend{tr} = clstTrajs{tr}.name;
                    bPrintLegend = true;
                else
                    clszLegend{tr} = '';
                end
            end % for tr
            
            if bPrintLegend
                legend(clszLegend, 'Interpreter', 'none');
            end
            
        end
    end % for f

    xlabel(szXLabel, 'Interpreter', 'none');
    linkaxes(vhAxes, 'x');
    
end % function plotTraj


function szLabel = getLabel(X, i)
    
    if (nargin < 2)
        i = 1;
    end
    
    szLabel = [];
    
    if isfield(X, 'name')
        if ( ischar(X.name) && (i == 1) )
            szLabel = X.name;
        else
            szLabel = X.name{i};
        end
        if isfield(X, 'unit')
            if ( ischar(X.name) && (i == 1) )
                szLabel = [szLabel ' [' X.unit ']'];
            else
                szLabel = [szLabel ' [' X.unit{i} ']'];
            end
        end
    end

end % subfunction getLabel

