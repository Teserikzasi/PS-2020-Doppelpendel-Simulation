function At = trajmat_wrap(t, A, stTraj)

    if (t <= stTraj.T.data(1))
        vX = stTraj.X.data(1,:)';
        vU = stTraj.U.data(1,:)';
    elseif (t >= stTraj.T.data(end))
        vX = stTraj.X.data(end,:)';
        vU = stTraj.U.data(end,:)';
    else
        vX = interp1(stTraj.T.data, stTraj.X.data, t)';
        vU = interp1(stTraj.T.data, stTraj.U.data, t);
    end
    
    At = A(vX, vU, t);

end % function trajmat_wrap
