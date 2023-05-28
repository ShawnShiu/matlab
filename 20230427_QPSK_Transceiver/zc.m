function Err = zc(multiple,start)
    len = length(start);
    if(multiple > len)
        multiple = len;
    end
    k = 1;
    k2 = round(multiple/2);
    k3 = multiple;
    rk_r = real(start);
    rk_i = imag(start);
    err1 = (rk_r(k2))*(sign(rk_r(k)) - sign(rk_r(k3)));
    err2 = (rk_r(k2))*(sign(rk_i(k)) - sign(rk_i(k3)));
    Err = err1 + err2;
end
