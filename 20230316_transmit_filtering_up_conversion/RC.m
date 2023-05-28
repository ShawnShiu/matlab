function rc = RC(alpha,W,t)
    rc = sinc(2*W*t) .* ( (cos(2*pi*alpha*W*t)) ./ (1-(16*(alpha.^2)*(W.^2)*(t.^2))) );
end