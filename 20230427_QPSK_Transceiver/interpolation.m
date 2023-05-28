function [rk,output] = phase_select(multi,idx,signal,tau)
    if( idx == 1 )
        rk = signal(1:end);
        output = rk(1);
    else
        jump = idx+multi;
        if( jump > length(signal)-1 )
            jump = length(signal)-1;
        end
        
        % new sampling
        output = tau*signal(idx) + (1-tau)*signal(jump);
        
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
