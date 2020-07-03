% Level 2 m-s-function : 'SchlittenPendelFunc.m'
%
% Created by sys2sfct at 02-Jul-2020 22:36:37 from the following system:
% Name        : SchlittenPendelNLZSR
% Description : Nichtlineare Zustandsraumdarstellung des Schlitten-Doppelpendel-Systems
%
% System type : NLTI
% State eq.   : dx=f(x,u)
% Output eq.  : y=h(x)
%
% Nb. Inputs  : 1
% Nb. States  : 6
% Nb. Outputs : 3
%
%     u = [ F ]'
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
    
    dx = [x(2); -(11*u(1) - 11*x(2) + 6*sin(2*x(3)) + sin(2*x(5)) - 19*x(4)^2*sin(x(3)) - 7*x(6)^2*sin(x(5)) - u(1)*cos(2*x(3) - 2*x(5)) + x(2)*cos(2*x(3) - 2*x(5)) - 2*x(4)*cos(2*x(3) - x(5)) + 2*x(6)*cos(2*x(3) - x(5)) + x(4)^2*sin(x(3) - 2*x(5)) - 14*x(4)*cos(x(3)) + 4*x(4)*cos(x(5)) + 7*x(6)*cos(x(3)) - 4*x(6)*cos(x(5)) - 3*x(6)^2*sin(2*x(3) - x(5)) + 2*x(4)*cos(x(3) - 2*x(5)) - x(6)*cos(x(3) - 2*x(5)))/(6*cos(2*x(3)) + cos(2*x(5)) + cos(2*x(3) - 2*x(5)) - 24); x(4); (22*x(4) - 11*x(6) - sin(x(3) - 2*x(5)) - 19*sin(x(3)) - 2*x(4)*cos(2*x(5)) + x(6)*cos(2*x(5)) + 7*x(6)^2*sin(x(3) - x(5)) + 6*x(4)^2*sin(2*x(3)) - 2*x(4)*cos(x(3) + x(5)) + 2*x(6)*cos(x(3) + x(5)) - 7*u(1)*cos(x(3)) + 7*x(2)*cos(x(3)) + x(4)^2*sin(2*x(3) - 2*x(5)) + u(1)*cos(x(3) - 2*x(5)) - x(2)*cos(x(3) - 2*x(5)) + 4*x(4)*cos(x(3) - x(5)) - 4*x(6)*cos(x(3) - x(5)) + 3*x(6)^2*sin(x(3) + x(5)))/(6*cos(2*x(3)) + cos(2*x(5)) + cos(2*x(3) - 2*x(5)) - 24); x(6); -(14*x(4) - 14*x(6) - 2*sin(2*x(3) - x(5)) + 8*sin(x(5)) - 4*x(4)*cos(2*x(3)) + 4*x(6)*cos(2*x(3)) - 2*u(1)*cos(2*x(3) - x(5)) + 2*x(2)*cos(2*x(3) - x(5)) + 8*x(4)^2*sin(x(3) - x(5)) - x(6)^2*sin(2*x(5)) - 4*x(4)*cos(x(3) + x(5)) + 2*x(6)*cos(x(3) + x(5)) + 4*u(1)*cos(x(5)) - 4*x(2)*cos(x(5)) + x(6)^2*sin(2*x(3) - 2*x(5)) + 8*x(4)*cos(x(3) - x(5)) - 4*x(6)*cos(x(3) - x(5)) - 2*x(4)^2*sin(x(3) + x(5)))/(6*cos(2*x(3)) + cos(2*x(5)) + cos(2*x(3) - 2*x(5)) - 24)];

    block.Derivatives.Data = dx;

end % function Derivative
