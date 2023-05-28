function arr = gray_code(len,bit)
    for c = 1:len
        val=dec2bin(bit(c),2);
        switch val
            case '00'
                arr(c)=1;
            case '01'
                arr(c)=-1;
        end
    end
end
