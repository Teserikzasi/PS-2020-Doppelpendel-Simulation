% Level 2 m-s-function : 'SchlittenPendelFunc.m'
%
% Created by sys2sfct at 31-Jul-2020 13:41:18 from the following system:
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
    
    dx = [x(2); ((1396067194330288159*atan(100*x(2)))/62500000000000000000 - (439479864190492909*atan(100*x(2))*cos(2*x(3) - 2*x(5)))/62500000000000000000 - (688056773942971*u(1)*pi)/1000000000000000000 + (11696965157030507*x(2)*pi)/1000000000000000000 - (1393532095626214587*pi*sin(2*x(3)))/1000000000000000000000 + (185421767934949029*pi*sin(2*x(5)))/2000000000000000000000 + (75040694977441907399966345263653*x(4)*pi*cos(x(3)))/2882303761517117440000000000000000000 - (1442466646233541323451898331*x(4)*pi*cos(x(5)))/1152921504606846976000000000000000 - (8467898453713071138416616693*x(6)*pi*cos(x(3)))/4611686018427387904000000000000000 + (1442466646233541323451898331*x(6)*pi*cos(x(5)))/1152921504606846976000000000000000 + (281630329648098809*x(6)^2*pi*sin(2*x(3) - x(5)))/20000000000000000000000 - (21040469095050509788776538584803*x(4)*pi*cos(x(3) - 2*x(5)))/2882303761517117440000000000000000000 + (2374292452501078009082269843*x(6)*pi*cos(x(3) - 2*x(5)))/4611686018427387904000000000000000 + (2909633112984444169*x(4)^2*pi*sin(x(3)))/40000000000000000000000 + (196069298932899781*x(6)^2*pi*sin(x(5)))/20000000000000000000000 + (216599243070721*u(1)*pi*cos(2*x(3) - 2*x(5)))/1000000000000000000 - (3682187132202257*x(2)*pi*cos(2*x(3) - 2*x(5)))/1000000000000000000 + (6957911319194367527859308249*x(4)*pi*cos(2*x(3) - x(5)))/4611686018427387904000000000000000 - (6957911319194367527859308249*x(6)*pi*cos(2*x(3) - x(5)))/4611686018427387904000000000000000 + (109816561845265429*x(4)^2*pi*sin(x(3) - 2*x(5)))/40000000000000000000000)/(pi*((1420522013890127*cos(2*x(3)))/10000000000000000000 - (189013015224209*cos(2*x(5)))/20000000000000000000 + (367155848431938909*cos(2*x(3) - 2*x(5)))/100000000000000000000 - 588577416889140817/50000000000000000000)); x(4); ((5614134288465905974376495172933*x(4)*pi)/1441151880758558720000000000000000 - (633521838710702537786276373*x(6)*pi)/2305843009213693952000000000000 + (2697766010557839*atan(100*x(2))*cos(x(3)))/31250000000000000 - (2258949822390724599*pi*sin(x(3)))/5000000000000000000 - (756419731825289*cos(x(3) - 2*x(5))*atan(100*x(2)))/31250000000000000 - (619930959228454509*pi*sin(x(3) - 2*x(5)))/5000000000000000000 - (1329603750891*u(1)*pi*cos(x(3)))/500000000000000 + (22603263765147*x(2)*pi*cos(x(3)))/500000000000000 + (367155848431938909*x(4)^2*pi*sin(2*x(3) - 2*x(5)))/100000000000000000000 + (372804204941*u(1)*pi*cos(x(3) - 2*x(5)))/500000000000000 - (6337671483997*x(2)*pi*cos(x(3) - 2*x(5)))/500000000000000 + (403193511008657879305585307*x(4)*pi*cos(x(3) - x(5)))/1152921504606846976000000000000 - (403193511008657879305585307*x(6)*pi*cos(x(3) - x(5)))/1152921504606846976000000000000 + (484733785969189*x(6)^2*pi*sin(x(3) + x(5)))/10000000000000000000 - (36214232521601565901508672263*x(4)*pi*cos(2*x(5)))/1441151880758558720000000000000000 + (4086561880380512924410103*x(6)*pi*cos(2*x(5)))/2305843009213693952000000000000 + (288484644588632333*x(6)^2*pi*sin(x(3) - x(5)))/50000000000000000000 + (1420522013890127*x(4)^2*pi*sin(2*x(3)))/10000000000000000000 - (11975750979680494884439429*x(4)*pi*cos(x(3) + x(5)))/2305843009213693952000000000000 + (11975750979680494884439429*x(6)*pi*cos(x(3) + x(5)))/2305843009213693952000000000000)/(pi*((1420522013890127*cos(2*x(3)))/10000000000000000000 - (189013015224209*cos(2*x(5)))/20000000000000000000 + (367155848431938909*cos(2*x(3) - 2*x(5)))/100000000000000000000 - 588577416889140817/50000000000000000000)); x(6); -((2216703089202427*atan(100*x(2))*cos(2*x(3) - x(5)))/31250000000000000 + (4316775375468673787551242879*x(4)*pi)/4611686018427387904000000000000 - (4316775375468673787551242879*x(6)*pi)/4611686018427387904000000000000 - (1816720022754958887*pi*sin(2*x(3) - x(5)))/5000000000000000000 - (459551742482913*atan(100*x(2))*cos(x(5)))/7812500000000000 + (748583704101805371*pi*sin(x(5)))/2500000000000000000 + (226491740997*u(1)*pi*cos(x(5)))/125000000000000 - (3850359596949*x(2)*pi*cos(x(5)))/125000000000000 + (367155848431938909*x(6)^2*pi*sin(2*x(3) - 2*x(5)))/100000000000000000000 + (3573014183137459080262154378347*x(4)*pi*cos(x(3) - x(5)))/720575940379279360000000000000000 - (403193511008657879305585307*x(6)*pi*cos(x(3) - x(5)))/1152921504606846976000000000000 + (553906405555987*x(4)^2*pi*sin(x(3) + x(5)))/20000000000000000000 - (35095176758699703002510447*x(4)*pi*cos(2*x(3)))/2305843009213693952000000000000 + (35095176758699703002510447*x(6)*pi*cos(2*x(3)))/2305843009213693952000000000000 - (1092510147463*u(1)*pi*cos(2*x(3) - x(5)))/500000000000000 + (18572672506871*x(2)*pi*cos(2*x(3) - x(5)))/500000000000000 + (491357163176906491*x(4)^2*pi*sin(x(3) - x(5)))/25000000000000000000 + (189013015224209*x(6)^2*pi*sin(2*x(5)))/20000000000000000000 - (106126529658365206330847312309*x(4)*pi*cos(x(3) + x(5)))/1441151880758558720000000000000000 + (11975750979680494884439429*x(6)*pi*cos(x(3) + x(5)))/2305843009213693952000000000000)/(pi*((1420522013890127*cos(2*x(3)))/10000000000000000000 - (189013015224209*cos(2*x(5)))/20000000000000000000 + (367155848431938909*cos(2*x(3) - 2*x(5)))/100000000000000000000 - 588577416889140817/50000000000000000000))];

    block.Derivatives.Data = dx;

end % function Derivative
