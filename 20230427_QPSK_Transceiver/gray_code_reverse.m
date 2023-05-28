% Decision boundary
function arr = gray_code_reverse(len,bit)
    for c = 1:len
        % Detection (Decision boundary)
        if bit(c) >= 0
            arr(c) = 1;
        else
            arr(c) = -1;
        end
    end
end
