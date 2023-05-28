% 20230302 Lab.3 Digital modulation
% Practice 1+2+3 :
% page 6 & 10
% 1.Generate a 16-QAM mapper (Gray mapping)
% 2.Map a bit sequence with the mappers.
% 3.add gaussian noise to have a SNR of 20dB
% 4.Check if your generation is right.
% 5.Calculate the probability of symbol error
clear all
clc
%%
%   Parameter
n = 10000;                              % Number of symbol
m = 16;                                 % Modulation order
k = log2(m);                            % Number of bits per symbol
bit_I = randi([0 3],n,1);               % Generate vector of 2bits binary data
bit_Q = randi([0 3],n,1);               % Generate vector of 2bits binary data
SignalPower = 4*(1^2+1^2)/16 + ...      % Avg SignalPower
              8*(1^2+3^2)/16 + ...
              4*(3^2+3^2)/16;          
SNR = [1:20];                           % SNR of 1~20 dB
sigma = SignalPower./(10.^(SNR./10));   % power of signal noise

%   create 16 QAM
xt=gray_code_2bits(n,bit_I) + 1i*gray_code_2bits(n,bit_Q);
%scatterplot(xt);

for c = 1:size(sigma.')
    %   add gaussian noise to have a SNR of 1~20 dB
    noise_I =    (sigma(c)/sqrt(2))*randn(1,n);
    noise_Q = 1i*(sigma(c)/sqrt(2))*randn(1,n);
    xt_n = xt + noise_I + noise_Q;
    scatterplot(xt_n);

    %   Detection and Decode
    [rec_sym_I,rec_bit_I] = gray_code_2bits_reverse(n,real(xt_n));
    [rec_sym_Q,rec_bit_Q] = gray_code_2bits_reverse(n,imag(xt_n));
    rec_xt = rec_sym_I + 1i*rec_sym_Q;

    %   SER
    err_sym = compare_array(n,rec_xt,xt);
    SER(c) = err_sym/n;
    
    %   BER
    err_bit = compare_array(n,rec_bit_I,bit_I) + ...
              compare_array(n,rec_bit_Q,bit_Q);
    BER(c) = err_bit/(n+n);
end

% Show chart
figure('color','w')
semilogy(SNR,100*SER,'o',SNR,100*BER,'*');
grid on;
title('16QAM');
xlabel('SNR(dB)');
ylabel('BER "*",SER "o" (%)');

