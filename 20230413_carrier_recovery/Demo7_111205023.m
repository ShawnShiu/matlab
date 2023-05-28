% 20230413 Lab.7 carrier recovery
% Practice 1 :
% page 7
% 1.Generate a QPSK sequence
% 2.Add the CFO effect
% 3.Use the DD carry recover method to recover the QPSK signel
% 4.Adjust the parameter of the PLL and see its effect
% 5.Find out the maximum CFO the carrier recovery method can tolerate
% 
%%
close all; clear all; clc;
%%
%% Parameters
fs = 1e6;           % Symbol rate
n = 10000;           % Number of symbols
t = 0:1/fs:(n-1)/fs;
cfo = 200;          % Carrier frequency offset

%% QPSK
bit_I=randi([0 1],n,1);             % Generate vector of 1bit binary data
bit_Q=randi([0 1],n,1);             % Generate vector of 1bit binary data
qpsk=gray_code(n,bit_I) + 1i*gray_code(n,bit_Q);

%% Add CFO
qpsk_cfo = qpsk .* exp(1i * 2 * pi * cfo * t);

figure(1);
subplot(1, 3, 1);
plot(real(qpsk), imag(qpsk), 'o');  grid on;
title('QPSK');

subplot(1, 3, 2);
plot(real(qpsk_cfo), imag(qpsk_cfo), 'o');  grid on;
title('QPSK with CFO');

%% Initialize PLL
alpha = 0.01;
beta =  0.001;
Ak  = zeros(1, n);
qk = zeros(1, n);
Ek = zeros(1, n);
gk = zeros(1, n);
sk = zeros(1, n);
ck = zeros(1, n);
phi_k = zeros(1, n);

for a = 2:length(qpsk_cfo)
    % decision detect
    qk(a) = qpsk_cfo(a) * exp(-1i * phi_k(a-1));
    Ak(a) = gray_code_reverse(1,real(qk(a))) + i*gray_code_reverse(1,imag(qk(a)));

    % phase detector
    Ek(a) = angle((qk(a)) * conj(Ak(a)));

    % loop filter
    sk(a) = (sk(a-1) + (beta * Ek(a))) ;
    gk(a) = alpha * Ek(a);
    ck(a) = gk(a) + sk(a);
    
    % VCO
    phi_k(a) = phi_k(a-1) + ck(a);
end
qk(1) = qpsk_cfo(1) * exp(-1i * phi_k(length(qpsk_cfo)));

subplot(1, 3, 3);
plot(real(qk), imag(qk), 'o'); grid on;
title('Recovered QPSK');
