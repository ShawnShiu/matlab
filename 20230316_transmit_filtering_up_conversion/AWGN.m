function [Eavg,sigma,noise] = AWGN(SNR_dB,signal,fs)
    Eavg = sum(abs(signal).^2)/length(signal);  % Avg Eavg
    sigma = Eavg/(10^(SNR_dB/10));              % power of signal noise
    noise = (sigma/sqrt(2))*randn(1,fs);        % Noise signal
end