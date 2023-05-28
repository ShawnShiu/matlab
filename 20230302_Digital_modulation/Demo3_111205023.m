% 20230302 Lab.3 Digital modulation
% Practice 1+2 :
% page 6 & 10
% 1.Generate a 16-QAM mapper (Gray mapping)
% 2.Map a bit sequence with the mappers.
% 3.add gaussian noise to have a SNR of 20dB
% 4.Check if your generation is right.
close all; clear all; clc;

%%
%   Parameter
n = 10000;                          % Number of symbol
m = 16;                             % Modulation order
k = log2(m);                        % Number of bits per symbol
bit_I=randi([0 3],n,1);             % Generate vector of 2bits binary data
bit_Q=randi([0 3],n,1);             % Generate vector of 2bits binary data
SignalPower=4*(1^2+1^2)/16 + 8*(1^2+3^2)/16 + 4*(3^2+3^2)/16;   % Avg SignalPower
SNR=20;                             % SNR of 20 dB
sigma = SignalPower/(10^(SNR/10));  % power of signal noise

%   create symbol
xt=gray_code_2bits(n,bit_I) + 1i*gray_code_2bits(n,bit_Q);
scatterplot(xt);

%   add gaussian noise to have a SNR of 20dB
noise_I =    (sigma/sqrt(2))*randn(1,n);
noise_Q = 1i*(sigma/sqrt(2))*randn(1,n);
xt=xt+noise_I+noise_Q;
scatterplot(xt);
