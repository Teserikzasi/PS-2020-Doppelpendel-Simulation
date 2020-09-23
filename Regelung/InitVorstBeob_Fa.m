function InitVorstBeob_Fa(sysF)
% Berechnet die notwendigen Gleichungen zwischen F<->a und initialisiert
% die betreffenden Simulink-Module für die Vorsteuerung und die Ermittlung
% der tatsächlichen Beschleunigung für den Beobachter.
% Mithilfe von matlabFunctionBlock wird die symbolische Gleichung in eine 
% matlab Funktion geschrieben. 
% Dazu muss Simulink geöffnet sein und es muss danach gespeichert werden.
% Mit save_system wird automatisch gespeichert.

equation_a = sysF.f(2); % Gleichung für die Beschleunigung x0_pp
equation_F = solve(str2sym('a')==equation_a, str2sym('F')); % Gleichung für die Kraft in Abh. von a
matlabFunctionBlock('SchlittenGleichungBeschleunigung/x0_pp', equation_a );
matlabFunctionBlock('SchlittenGleichungKraft/F0', equation_F );
save_system('SchlittenGleichungBeschleunigung');
save_system('SchlittenGleichungKraft');

disp('Simulink Module für Vorsteuerung/Beobachter F<->a aktualisiert')% (evtl Speichern notwendig)

end