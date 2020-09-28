%function varargout = animateDPendulum(mX, vT, stPendulum, dTimeFactor, hAxes)
%function varargout = animateDPendulum(clstTraj, stPendulum, dTimeFactor, hAxes)

function varargout = animateDPendulum(clstTraj, stPendulum, dTimeFactor, hAxes)
%
% Plottet Animation des Doppelpendels.
%
% Parameter:
%	mX			Matrix mit Zustandsdaten des Doppelpendels.
%				Der Systemzustand ist dabei durch Spaltenvektoren zu den
%				in vT angegebenen Zeitpunkten gegeben. Die Zustände sind:
%					Weg (1) und Geschwindigkeit (2) Schlitten
%					Winkel (3) und Winkelgeschwindigkeit (4) Pendel 1
%					Winkel (5) und Winkelgeschwindigkeit (6) Pendel 2
%				ODER
%				Cellarray mit beschriebenen Matrizen besitzen.
%				In diesem Fall wird	zu jedem dieser Zustandsdatensätzen
%				parallel eine Animation gezeigt.
%				(Für alle im Cell-Array befindliche Matrizen muss der selbe
%				Zeitvektor vT gelten!)
%
%	vT			Zeitvektor, der zu den Zustandsdaten gehört.
%
%	stPendulum	Struktur mit Pendeldaten 
%
%	dTimeFactor	Faktor mit dem die Zeit in der Animation ablaufen soll.
%				
%	hAxes		Handle des Achsensystems, in welches gezeichnet werden
%				soll. Wenn [], dann wird neues Figure mit Achsensystem
%				erstellt. (Nur möglich, wenn nur ein Satz Zustandsdaten
%				übergeben wurde, ansonsten muss es [] sein.)
%				Optional, Standardwert ist []
%
% Rückgabewert:
%	vstFrames	Struktur mit Frames der Animation.
%				Abspielen z.B. mit movie(figure, vstFrames, 1, 10)
%				Optional
%

	
	if (nargin < 4), hAxes = []; end % Standardwert für hAxes ist []
	if (nargin < 3), dTimeFactor = []; end
		
	if ~iscell(clstTraj)
		clstTraj = {clstTraj};
	end

	for s = 1:length(clstTraj)
		if iscell(clstTraj{s})
			stTrajTmp.T.data = clstTraj{s}{1};

			if ( size(clstTraj{s}{2}, 3) == length(clstTraj{s}{1}) )
				clstTraj{s}{2} = shiftdim(clstTraj{s}{2}, 2);
			end
			
			ts = size(clstTraj{s}{2}, 2);
			if ( (ts == 2) || (ts == 3) )
				stTrajTmp.Y.data = clstTraj{s}{2};
			else
				stTrajTmp.X.data = clstTraj{s}{2};
				
				if (ts == 4)
					stTrajTmp.Y.data = stTrajTmp.X.data(:, [1 3]);
				elseif (ts == 6)
					stTrajTmp.Y.data = stTrajTmp.X.data(:, [1 3 5]);
				end
			end

			clstTraj{s} = stTrajTmp;
		else
			if ~isfield(clstTraj{s}, 'Y')
				ts = size(clstTraj{s}.X, 2);
				
				if (ts == 4)
					clstTraj{s}.Y.data = clstTraj{s}.X.data(:, [1 3]);
				elseif (ts == 6)
					clstTraj{s}.Y.data = clstTraj{s}.X.data(:, [1 3 5]);
				end
			end
		end
	end % for s

	
	% Anzahl der Sätze an Zustandsdaten feststellen
	nXSets = length(clstTraj);
	
	dT0 = inf;
	dTe = -inf;
	
	for s = 1:nXSets
		dT0 = min(dT0, clstTraj{s}.T.data(1));
		dTe = max(dTe, clstTraj{s}.T.data(end));
	end % for s
	

	dTimeSpan = dTe - dT0;
	if isempty(dTimeFactor)
		if ( (dTimeSpan >= 4) && (dTimeSpan <= 10) )
			dTimeFactor = 1;
		elseif (dTimeSpan < 4)
			dTimeFactor = 4 / dTimeSpan;
		else
			dTimeFactor = 10 / dTimeSpan;
		end
	end
	
	% Festlegen der zu zeichnenden Zeitpunkte
	dFramesPerSecond = 10;
	dTimeStep = 1/dFramesPerSecond;
	dTimeStep = dTimeStep * dTimeFactor;
	
	vTplot = dT0:dTimeStep:dTe;
	

	clmY = cell(1, nXSets);
	
	for s = 1:nXSets
		mY = interp1(clstTraj{s}.T.data, clstTraj{s}.Y.data, vTplot, 'pchip', nan);

		idLeadingNan = find(~isnan(mY(:,1)), 1) - 1;
		idFollowingNan = find(~isnan(mY(:,1)), 1, 'last') + 1;

		for k = 1:idLeadingNan
			mY(k,:) = clstTraj{s}.Y.data(1,:);
		end
		for k = idFollowingNan:size(mY,1)
			mY(k,:) = clstTraj{s}.Y.data(end,:);
		end

		clmY{s} = mY;
	end
	
	vT = vTplot;
	
	% Falls kein Rückgabewert verlangt wird, werden die Frames
	% der Animation nicht gespeichert.
	if (nargout == 0)
		bRecFrames = false;
		vstFrames = [];
	else
		bRecFrames = true;
	end
	
	
	
	% Zum Zeichnen wesentlichen Orte bestimmen. Diese sind
	%	- vS0x       : Position Schlitten = Pendelanfang 1
	%	- vS1x, vS1y : Pendelende 1 = Pendelanfang 2
	%	- vS2x, vS2y : Pendelende 2
	% Dabei gleich maximaler Wert s0max der Schlittenposition
	% bestimmen, für die spätere Achsenskalierung.
	
	s0max = [];
	
	for s = 1:nXSets
		if (size(clmY{s}, 2) == 2)
			vstS(s).nLinks = 1;
		else
			vstS(s).nLinks = 2;
		end
		
		vstS(s).vS0x = clmY{s}(:,1); %#ok<AGROW>
		vstS(s).vS1x = vstS(s).vS0x - stPendulum.l1 * sin(clmY{s}(:,2));
		vstS(s).vS1y = stPendulum.l1 * cos(clmY{s}(:,2));
		
		if (vstS(s).nLinks == 1)
			s0max =  max( [abs(vstS(s).vS0x); abs(vstS(s).vS1x); s0max] );
		elseif (vstS(s).nLinks == 2)
			vstS(s).vS2x = vstS(s).vS1x - stPendulum.l2 * sin(clmY{s}(:,3));
			vstS(s).vS2y = vstS(s).vS1y + stPendulum.l2 * cos(clmY{s}(:,3));
			s0max =  max( [abs(vstS(s).vS0x); abs(vstS(s).vS1x); ...
									abs(vstS(s).vS2x); s0max] );
		end
	end
	
	% Achsenbegrenzungen berechnen
	if isfield(stPendulum, 'l2')
		lges = stPendulum.l1 + stPendulum.l2;	
	else
		lges = stPendulum.l1;
	end
	
	vRange = [-s0max-0.1, s0max+0.1, -lges-0.1 lges+0.1];
%	vRange = [-lges-s0max, lges+s0max, -lges, lges];

	% N ist Anzahl der Zeitschritte
	N = length(vT);
	
	% Anzahl Frames berechnet sich über übergegebenes dF
	F = N;

	% Wenn kein Handle auf ein Achsensystem übergeben wurde wird ein
	% neues Figure erzeugt. Ansonsten wird überprüft, ob auch nur ein
	% Satz an Zustandsdaten übergeben wurde. Es wird ein Fehler aus-
	% gegeben, wenn dies nicht der Fall ist.
	if isempty(hAxes)
		hFig = figure;
	else
		if (nXsets > 1)
			disp('Bei vorgegebenen Achsen kein Mehrfachplot');
			return;
		end
		
		% Gewünschtes Achsensystem als aktives Achsensystem setzen.
		% (Dies ist nötig, da später mit dem line-Befehl gezeichnet
		% wird. Würde plot verwendet werden, könnte man darauf ver-
		% zichten, da bei plot optional als erstes Argument ein Handle
		% des zu benutzenden Achsensystems übergeben werden kann.)
		axes(hAxes);
		% Mit den Achsensystem ist automatisch auch das Figure, in
		% welches es eingebetet ist aktiviert. Also kann mit gcf 
		% (get current figure) das Handle des Figures ermittelt werden.
		% Das wird gebraucht, wenn später mit getframe der Inhalt des
		% Figure gespeichert werden soll.
		hFig = gcf();
	end

	% Die Achsensysteme initialisieren.
	for s = 1:nXSets
		% Wenn nur ein Achsensystem benötigt wird (nur ein Satz an
		% Zustandsdaten übergeben wurde) UND ein Achsensystem mit
		% hAxes vorgegeben wurde, dann wird dieses einfach übernommen.
		% Ansonsten werden die Achsensysteme mit subplot erzeugt.
		if ((nXSets == 1) && (~isempty(hAxes)))
			vhAxes(s) = hAxes;
		else
			vhAxes(s) = subplot(nXSets, 1, s); %#ok<AGROW>
		end
		
%		set(vhAxes(s), 'XLimMode', 'manual', 'YLimMode', 'manual');

		axis(vRange);
		xlabel('x [m]');
		ylabel('y [m]');
	
		set(vhAxes(s), 'DataAspectRatio', [1 1 1]);

		% hold einschalten, damit bei den später verwendeten
		% plot-Befehlen der vorhandene Inhalt nicht gelöscht wird.
		hold(vhAxes(s), 'on');

		% Ausgangslage des Pendels in Schwarz zeichnen
		plot(vhAxes(s), ...
					[vstS(s).vS0x(1) vstS(s).vS1x(1)], ...
					[0 vstS(s).vS1y(1)], 'Color', 'k');
		if (vstS(s).nLinks == 2)
			plot(vhAxes(s), ...
					[vstS(s).vS1x(1) vstS(s).vS2x(1)], ...
					[vstS(s).vS1y(1) vstS(s).vS2y(1)], 'Color', 'k');
		end

	end
		
	vhLine1 = zeros(nXSets, 1);
	vhLine2 = zeros(nXSets, 1);
	vhCart = zeros(nXSets, 1);
	
	% Schleife über alle zu erzeugenden Frames
	for f = 1:F
		% Aktuelle Zeit und Framenummer im Titel des ersten (obersten)
		% Achsensystems anzeigen.
		szTitle = ['t = ' num2str(vT(f)) ' sec ' ...
					'(Zeitfaktor = ' num2str(dTimeFactor) 'x, ' ...
					'Frame ' num2str(f) '/' num2str(F) ')'];
		title(vhAxes(1), szTitle);
		% Man könnte den Titel auch mit 'set(vhAxes(1), ...)' ändern,
		% aber das ist deutlich aufwendiger.

		% Schleife über alle Sätze an Zustandsdaten
		for s = 1:nXSets
			% Pendelstäbe zeichnen
			% Beim ersten Mal müssen die Stäbe komplett neu gezeichnet
			% werden, ab dem zweiten Frame werden dann nur die Daten
			% ersetzt.
			xCart = vstS(s).vS0x(f);
			if (f == 1)
				axes(vhAxes(s));
				vhCart(s) = rectangle('Position', ...
										[xCart-0.08 -0.05 0.16 0.1], ...
										'FaceColor', 'k');
				vhLine1(s) = plot(vhAxes(s), ...
								[vstS(s).vS0x(f) vstS(s).vS1x(f)], ...
								[0 vstS(s).vS1y(f)], ...
								'Color', 'r', 'LineWidth', 5);
				
				if (vstS(s).nLinks == 2)
					vhLine2(s) = plot(vhAxes(s), ...
								[vstS(s).vS1x(f) vstS(s).vS2x(f)], ...
								[vstS(s).vS1y(f) vstS(s).vS2y(f)], ...
								'Color', 'b', 'LineWidth', 3);
				end
			else
				set(vhCart(s), ...
						'Position', [xCart-0.06 -0.04 0.12 0.08]);
				
 				set(vhLine1(s), ...
						'Xdata', [vstS(s).vS0x(f) vstS(s).vS1x(f)], ...
						'Ydata', [0 vstS(s).vS1y(f)]);
				
				if (vstS(s).nLinks == 2)
	 				set(vhLine2(s), ...
						'Xdata', [vstS(s).vS1x(f) vstS(s).vS2x(f)], ...
						'Ydata', [vstS(s).vS1y(f) vstS(s).vS2y(f)]);
				end

				% Weg der Pendelspitze weiter(!)zeichnen
				if (vstS(s).nLinks == 1)
					plot(vhAxes(s), ...
							vstS(s).vS1x(f-1:f), vstS(s).vS1y(f-1:f), 'g');
				else
					plot(vhAxes(s), ...
							vstS(s).vS2x(f-1:f), vstS(s).vS2y(f-1:f), 'g');
				end
			end
 
		end

		% Falls die Frames aufgezeichnet werden sollen, dies mit 
		% getframe tun, ansonsten eine Pause einfügen.
		% (getframe braucht so lange, dass eine Pause nicht nötig ist.)
		if bRecFrames
			vstFrames(f) = getframe(hFig); %#ok<AGROW>
		else
			pause(1/dFramesPerSecond);
		end
		
	end
	
	% Der lieben Ordnung halber:
	% hold der Achsensysteme wieder aufheben.
	for s=1:nXSets
		hold(vhAxes(s), 'off');
	end

	if (nargout > 0)
		varargout{1} = vstFrames;
	end
	
end