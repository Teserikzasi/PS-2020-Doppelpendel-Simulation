function stTrajSim = simSys(stSys, stTraj, vT)

    if (nargin < 3), vT = []; end
    
    
    fctU = [];
    
    if iscell(stTraj)
        
        if isstruct(stTraj{1})
            x0 = stTraj{2};
            stTraj = stTraj{1};
        elseif isa(stTraj{1}, 'function_handle')
            x0 = stTraj{2};
            fctU = stTraj{1};
            
            if isempty(vT)
                error('vT muss angegeben werden, wenn keine Trajektorie angegeben!');
            end
        else
            clTmp = stTraj;
            clear stTraj;
            stTraj.T.data = clTmp{1};
            stTraj.U.data = clTmp{2};
            x0 = clTmp{3};

            if isempty(vT)
                error('vT muss angegeben werden, wenn keine Trajektorie angegeben!');
            end
        end
    else
        x0 = stTraj.X.data(1,:)';
    end
    
    if isempty(fctU)
        fctU = @(t) trajsignal_wrap(t, stTraj.T.data, stTraj.U);
    end
    
    [fctF, fctH] = sys2fcts(stSys, 'TimeVarying', true); %#ok<NASGU>
    
    odeFct = @(t, x) fctF(x, fctU(t), t);
    
    if (isempty(vT))
        vT = stTraj.T.data;
    end
    
    [vT mX] = ode45(odeFct, vT, x0);
    
    
    stTrajSim.T.data = vT;

    stTrajSim.U.data = zeros(length(vT), length(fctU(0)));
    for it = 1:length(vT)
        stTrajSim.U.data(it,:) = fctU(vT(it));
    end % for it
    stTrajSim.X.data = mX;

    %stTrajSim.T = copySignalInfo(stTrajSim.T, stSys.t);
    stTrajSim.X = copySignalInfo(stTrajSim.X, stSys.x);
    stTrajSim.U = copySignalInfo(stTrajSim.U, stSys.u);


    if (isfield(stSys, 'y'))
        q = length(fctH( stTrajSim.X.data(1,:)', stTrajSim.U.data(1,:)', 0));
        nT = length(stTrajSim.T.data);
        stTrajSim.Y.data = zeros(nT, q);
        for it = 1:nT
            stTrajSim.Y.data(it,:) = fctH( stTrajSim.X.data(it,:)', ...
                                            stTrajSim.U.data(it,:)', ...
                                            stTrajSim.T.data(it));
        end % for it

        stTrajSim.Y = copySignalInfo(stTrajSim.Y, stSys.y);
    end
    
end % function simSys
