function plot_outputs(out)
    % Erstellt Plots von x, phi1 und phi2
    
    % Data konvertieren von 3-dim. zu 1-dim 
    x1 = [];
    phi1 = [];
    phi2 = [];
    for i=1:length(out.mY.Data(1,1,:))
       x1(i) = out.mY.Data(1, 1, i);
       phi1(i) = out.mY.Data(2, 1, i);
       phi2(i) = out.mY.Data(2, 1, i);
    end
    
    % Plotting
    figure
    
    subplot(3,1,1);
	plot(out.mY.Time, x1);
	ylabel('Weg [m]');
    
    subplot(3,1,2);
	plot(out.mY.Time, phi1);
	ylabel('Winkel 1 [rad]');
    
    subplot(3,1,3);
	plot(out.mY.Time, phi2);
	ylabel('Winkel 2 [rad]');
    
    xlabel('Zeit t [s]');
    
end