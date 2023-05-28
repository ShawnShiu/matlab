% Decision boundary
% 0~2   = 1
% >2    = 3
% 0~-2  = -1
% <-2   = -3
function [sym,bit] = gray_code_2bits_reverse(len,sig_amp)
    for c = 1:len
        % Detection (Decision boundary)
        if sig_amp(c) >= 0
            if sig_amp(c) >= 2
                sym(c) = 3;
            else
                sym(c) = 1;
            end
        else
            if sig_amp(c) <= -2
                sym(c) = -3;
            else
                sym(c) = -1;
            end
        end
        
        % Decode
        switch sym(c)
            case -3
                bit(c)=bin2dec('00');
            case -1
                bit(c)=bin2dec('01');
            case 3
                bit(c)=bin2dec('10');
            case 1
                bit(c)=bin2dec('11');
        end
    end
end
