function val = trajsignal_wrap(t, vT, stSignal)
    
    if (t < vT(1))
        if isfield(stSignal, 'initdata')
            val = stSignal.initdata;
        else
            val = shiftdim( stSignal.data(1,:,:), 1 );
        end
    elseif (t > vT(end))
        if isfield(stSignal, 'enddata')
            val = stSignal.enddata;
        else
            val = shiftdim( stSignal.data(end,:,:), 1 );
        end
    else
        val = reshape(interp1(vT, stSignal.data, t), ...
                                        size(stSignal.data, 2), ...
                                        size(stSignal.data, 3));
    end

end % function trajsignal_wrap
