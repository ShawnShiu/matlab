% Decision boundary
function N = power_of_N(Ak)
    switch (angle(Ak))
        case (pi/4)
            N=8;
        case (3*pi/4)
            N=8;
        case (-pi/4)
            N=8;
        case (-3*pi/4)
            N=8;
    end
end
