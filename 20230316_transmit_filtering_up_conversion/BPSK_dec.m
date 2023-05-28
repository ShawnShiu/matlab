function bpsk_dec = BPSK_dec(bpsk,max,min)
    avg = (max+min)/2;
    for c = 1:length(bpsk)
        if ((bpsk(c) >= max) || (bpsk(c) >= avg))
            bpsk_dec(c) = 1;
        else 
            bpsk_dec(c) = 0;
        end
    end
end
