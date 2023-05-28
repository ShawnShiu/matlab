function arr = gray_code_2bits(len,bit)
    for c = 1:len
        val=dec2bin(bit(c),2);
        switch val
            case '00'
                arr(c)=-3;
            case '01'
                arr(c)=-1;
            case '10'
                arr(c)=3;
            case '11'
                arr(c)=1;
        end
    end
end
