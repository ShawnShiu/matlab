function srrc = SRRC(alpha,n,M)
    len = length(n);
    srrc = (4*alpha/pi) * ( cos((1+alpha)*pi*n/M) + (( M*sin((1-alpha)*pi*n/M)) ./ (4*alpha*n)) ) ./ (1-((4*alpha*n/M).^2));
    srrc(1,1) = 0;
    srrc(1,len) = 0;
end