@@ABOUT@@

function @@SFCTNAME@@(block)

  setup(block);
  
end % function Systemgleichung

function setup(block)

    %% Register number of dialog parameters
    block.NumDialogPrms = 2 + @@PARAMPARAM@@;

    %% Set block sample time to continuous
    block.SampleTimes = [0 0];

    %stParam = block.DialogPrm(@@PARAMPARAM@@).Data;
    %x0 = block.DialogPrm(1+@@PARAMPARAM@@).Data;
    bShowStates = block.DialogPrm(2+@@PARAMPARAM@@).Data;
    
    % Dimensionen feststellen, wenn nicht explizit gegeben
    
    block.NumContStates = @@NSTATES@@;
    
    %% Register number of input and output ports
    
    nInputs = @@NINPUTS@@;
    
    if (nInputs == 0)
        block.NumInputPorts = 0;
    else
        block.NumInputPorts = 1;
        block.InputPort(1).Dimensions = [nInputs, 1];
        block.InputPort(1).DirectFeedthrough = @@BDIRECTFEEDTHROUGH@@;
    end

    
    if (bShowStates)
        block.NumOutputPorts = 2;
    else
        block.NumOutputPorts = 1;
    end
    
    block.OutputPort(1).Dimensions = [@@NOUTPUTS@@, 1];
    
    if (bShowStates)
        block.OutputPort(2).Dimensions = [@@NSTATES@@, 1];
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
    x0 = block.DialogPrm(1+@@PARAMPARAM@@).Data;
    
    if ( (length(x0) == 1) && (x0 == 0) )
        x0 = zeros(block.NumContStates, 1);
    end

    block.ContStates.Data = x0;
  
end % function InitConditions


function Output(block)

    bShowStates = block.DialogPrm(2+@@PARAMPARAM@@).Data;
    
    x = block.ContStates.Data;
    t = block.CurrentTime;
    
    if (@@NPARAMS@@ > 0)
        p = block.DialogPrm(@@PARAMPARAM@@).Data;
    end


    bDirectFeedthrough = @@BDIRECTFEEDTHROUGH@@;
    if (bDirectFeedthrough)
        u = block.InputPort(1).Data;
    end

    y = @@OUTPUTEQ@@;
    
    block.OutputPort(1).Data = y;
    
    if bShowStates
        block.OutputPort(2).Data = x;
    end

end % function Output


function Derivative(block)

    nInputs = @@NINPUTS@@;
    if (nInputs > 0)
        u = block.InputPort(1).Data;
    end
    
    if (@@NPARAMS@@ > 0)
        p = block.DialogPrm(@@PARAMPARAM@@).Data;
    end

    x = block.ContStates.Data;
    t = block.CurrentTime;
    
    dx = @@STATEEQ@@;

    block.Derivatives.Data = dx;

end % function Derivative
