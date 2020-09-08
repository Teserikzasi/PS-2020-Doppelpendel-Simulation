% Level 2 m-s-function : 'SchlittenPendelFunc.m'
%
% Created by sys2sfct at 08-Sep-2020 16:06:34 from the following system:
% Name        : SchlittenPendel NLZSR (u) Fauve
% Description : Nichtlineare Zustandsraumdarstellung des Schlitten-Doppelpendel-Systems (Eingang: u )
%
% System type : NLTI
% State eq.   : dx=f(x,u)
% Output eq.  : y=h(x)
%
% Nb. Inputs  : 1
% Nb. States  : 6
% Nb. Outputs : 3
%
%     u = [ u ]'
%     x = [ x0, x0_p, phi1, phi1_p, phi2, phi2_p ]'
%     y = [ x0, phi1, phi2 ]'
%
% Nb. Params  : 0
%
%

function SchlittenPendelFunc(block)

  setup(block);
  
end % function Systemgleichung

function setup(block)

    %% Register number of dialog parameters
    block.NumDialogPrms = 2 + 0;

    %% Set block sample time to continuous
    block.SampleTimes = [0 0];

    %stParam = block.DialogPrm(0).Data;
    %x0 = block.DialogPrm(1+0).Data;
    bShowStates = block.DialogPrm(2+0).Data;
    
    % Dimensionen feststellen, wenn nicht explizit gegeben
    
    block.NumContStates = 6;
    
    %% Register number of input and output ports
    
    nInputs = 1;
    
    if (nInputs == 0)
        block.NumInputPorts = 0;
    else
        block.NumInputPorts = 1;
        block.InputPort(1).Dimensions = [nInputs, 1];
        block.InputPort(1).DirectFeedthrough = false;
    end

    
    if (bShowStates)
        block.NumOutputPorts = 2;
    else
        block.NumOutputPorts = 1;
    end
    
    block.OutputPort(1).Dimensions = [3, 1];
    
    if (bShowStates)
        block.OutputPort(2).Dimensions = [6, 1];
    end



    %% Register methods
    block.RegBlockMethod('SetInputPortSamplingMode',    @SetInputPortSMode);
    block.RegBlockMethod('Outputs',                        @Output);  
    block.RegBlockMethod('InitializeConditions',        @InitConditions);
    block.RegBlockMethod('Derivatives',                    @Derivative);  

end % function setup


function SetInputPortSMode(block, idx, fd)

    block.InputPort(idx).SamplingMode = fd;
    
    if (idx == 1)
        for o = 1:block.NumOutputPorts
            block.OutputPort(o).SamplingMode = fd;
        end % for o
    end
    
end % function SetInputPortSMode


function InitConditions(block)  

    % Initialize Dwork
    x0 = block.DialogPrm(1+0).Data;
    
    if ( (length(x0) == 1) && (x0 == 0) )
        x0 = zeros(block.NumContStates, 1);
    end

    block.ContStates.Data = x0;
  
end % function InitConditions


function Output(block)

    bShowStates = block.DialogPrm(2+0).Data;
    
    x = block.ContStates.Data;
    t = block.CurrentTime;
    
    if (0 > 0)
        p = block.DialogPrm(0).Data;
    end


    bDirectFeedthrough = false;
    if (bDirectFeedthrough)
        u = block.InputPort(1).Data;
    end

    y = [x(1); x(3); x(5)];
    
    block.OutputPort(1).Data = y;
    
    if bShowStates
        block.OutputPort(2).Data = x;
    end

end % function Output


function Derivative(block)

    nInputs = 1;
    if (nInputs > 0)
        u = block.InputPort(1).Data;
    end
    
    if (0 > 0)
        p = block.DialogPrm(0).Data;
    end

    x = block.ContStates.Data;
    t = block.CurrentTime;
    
    dx = [x(2); -((226164004253423*u(1))/500000000000000000 - (3844788072308191*x(2))/500000000000000000 - (12010145509061552148592860481057*x(4))/720575940379279360000000000000000000 + (1355273863276768643437360817*x(6))/1152921504606846976000000000000000 + (15496715954919574467*sin(x(3)))/6250000000000000000000 + (708393904059*cos(x(5))*((6368738391448223*x(4))/9223372036854775808 - (6368738391448223*x(6))/9223372036854775808 + (24849711*sin(x(5)))/50000000 + (14717311*x(4)^2*sin(x(3) - x(5)))/1000000000))/200000000000000 + (16788832527744349559*x(4)^2*sin(x(3)))/250000000000000000000000 - (5728960391743458013*x(6)^2*sin(x(5)))/250000000000000000000000 - (1092510147463*cos(x(3) - x(5))*((6368738391448223*x(4))/9223372036854775808 - (6368738391448223*x(6))/9223372036854775808 + (24849711*sin(x(5)))/50000000 + (14717311*x(4)^2*sin(x(3) - x(5)))/1000000000))/500000000000000 - (3131858416856725969*x(6)^2*sin(x(3) - x(5)))/125000000000000000000000 - (216599243070721*cos(x(3) - x(5))^2*(u(1) - 17*x(2) + (74233*x(4)^2*sin(x(3)))/500000 - (25331*x(6)^2*sin(x(5)))/500000))/1000000000000000000 + (132146735469*cos(x(3) - x(5))*cos(x(5))*((56438389954266676783*x(4))/5764607523034234880000 - (6368738391448223*x(6))/9223372036854775808 - (72822573*sin(x(3)))/50000000 + (14717311*x(6)^2*sin(x(3) - x(5)))/1000000000))/100000000000000)/((15796856223159607*cos(x(3)))/62500000000000000000 + (17944325983718529*cos(x(5))^2)/100000000000000000000 - (27674374545385253*cos(x(3) - x(5))*cos(x(5)))/250000000000000000000 + (1891127991250465051*cos(x(3) - x(5))^2)/500000000000000000000 - (9809648614070277*cos(x(3) - x(5))*cos(x(3))*cos(x(5)))/50000000000000000000 - 1974637921136636213/250000000000000000000); x(4); -((159402100147770762677671619*x(6))/1152921504606846976000000000000 - (1412587130246876885069500961299*x(4))/720575940379279360000000000000000 + (1822664138623022169*sin(x(3)))/6250000000000000000 + (212800994479*cos(x(3))*(u(1) - 17*x(2) + (74233*x(4)^2*sin(x(3)))/500000 - (25331*x(6)^2*sin(x(5)))/500000))/125000000000000 - (128496842341*cos(x(3) - x(5))*((6368738391448223*x(4))/9223372036854775808 - (6368738391448223*x(6))/9223372036854775808 + (24849711*sin(x(5)))/50000000 + (14717311*x(4)^2*sin(x(3) - x(5)))/1000000000))/500000000000 - (368357143555778083*x(6)^2*sin(x(3) - x(5)))/125000000000000000000 + (227447049*cos(x(5))^2*((56438389954266676783*x(4))/5764607523034234880000 - (6368738391448223*x(6))/9223372036854775808 - (72822573*sin(x(3)))/50000000 + (14717311*x(6)^2*sin(x(3) - x(5)))/1000000000))/50000000000 - (372804204941*cos(x(3) - x(5))*cos(x(5))*(u(1) - 17*x(2) + (74233*x(4)^2*sin(x(3)))/500000 - (25331*x(6)^2*sin(x(5)))/500000))/500000000000000 + (666538107*cos(x(3))*cos(x(5))*((6368738391448223*x(4))/9223372036854775808 - (6368738391448223*x(6))/9223372036854775808 + (24849711*sin(x(5)))/50000000 + (14717311*x(4)^2*sin(x(3) - x(5)))/1000000000))/50000000000)/((15796856223159607*cos(x(3)))/62500000000000000000 + (17944325983718529*cos(x(5))^2)/100000000000000000000 - (27674374545385253*cos(x(3) - x(5))*cos(x(5)))/250000000000000000000 + (1891127991250465051*cos(x(3) - x(5))^2)/500000000000000000000 - (9809648614070277*cos(x(3) - x(5))*cos(x(3))*cos(x(5)))/50000000000000000000 - 1974637921136636213/250000000000000000000); x(6); -((4386965728986073193556263773*x(4))/9223372036854775808000000000000 - (4386965728986073193556263773*x(6))/9223372036854775808000000000000 + (17117178290537186061*sin(x(5)))/50000000000000000000 - (5510538289*cos(x(3))*((6368738391448223*x(4))/9223372036854775808 - (6368738391448223*x(6))/9223372036854775808 + (24849711*sin(x(5)))/50000000 + (14717311*x(4)^2*sin(x(3) - x(5)))/1000000000))/250000000000 + (1998477111451*cos(x(5))*(u(1) - 17*x(2) + (74233*x(4)^2*sin(x(3)))/500000 - (25331*x(6)^2*sin(x(5)))/500000))/1000000000000000 + (10137696826505713661*x(4)^2*sin(x(3) - x(5)))/1000000000000000000000 - (1880396123*cos(x(5))*((56438389954266676783*x(4))/5764607523034234880000 - (6368738391448223*x(6))/9223372036854775808 - (72822573*sin(x(3)))/50000000 + (14717311*x(6)^2*sin(x(3) - x(5)))/1000000000))/250000000000 + (128496842341*cos(x(3) - x(5))*((56438389954266676783*x(4))/5764607523034234880000 - (6368738391448223*x(6))/9223372036854775808 - (72822573*sin(x(3)))/50000000 + (14717311*x(6)^2*sin(x(3) - x(5)))/1000000000))/500000000000 - (1092510147463*cos(x(3) - x(5))*cos(x(3))*(u(1) - 17*x(2) + (74233*x(4)^2*sin(x(3)))/500000 - (25331*x(6)^2*sin(x(5)))/500000))/500000000000000)/((15796856223159607*cos(x(3)))/62500000000000000000 + (17944325983718529*cos(x(5))^2)/100000000000000000000 - (27674374545385253*cos(x(3) - x(5))*cos(x(5)))/250000000000000000000 + (1891127991250465051*cos(x(3) - x(5))^2)/500000000000000000000 - (9809648614070277*cos(x(3) - x(5))*cos(x(3))*cos(x(5)))/50000000000000000000 - 1974637921136636213/250000000000000000000)];

    block.Derivatives.Data = dx;

end % function Derivative
