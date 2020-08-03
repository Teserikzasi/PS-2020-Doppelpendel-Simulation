
%hold on
%title('Eigenwerte')

for i=1:4
    disp(' ')
    disp(['Arbeitspunkt: ' int2str(i)])
    
    syslin = Linearisierung(sys,Ruhelagen(i));
    ew = eig(syslin.A)
    
    figure
    plot(real(ew),imag(ew),'x','MarkerSize',15,'LineWidth',1)
    grid on
    title(['Eigenwerte: ' 'AP ' int2str(i)])
    
    stbar = rank(ctrb(syslin.A, syslin.B))==length(syslin.A);
    if stbar
        disp('System steuerbar')
    else
        disp('System NICHT steuerbar!')
    end
    
    beobar = rank(obsv(syslin.A, syslin.C))==length(syslin.A);
    if beobar
        disp('System beobachtbar')
    else
        disp('System NICHT beobachtbar!')
    end
    
end