function rk = phase_select(multi,idx,signal,tau)
    if( idx == 1 )
        rk = signal(1:end);
    else
        if( tau > 0 )
            % too slow, earlier to get point
            sel = idx+round(tau);
        elseif( tau < 0)
            % too fast, delay to get point
            sel = idx+round(tau);
        else
            % correctly
            sel = idx;
        end
        if( sel > length(signal)-1 )
            sel = length(signal)-1;
        end
        rk = signal(sel:end);
    end
end
