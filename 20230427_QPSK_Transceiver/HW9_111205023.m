% 20230420 Lab.9 carrier recovery
% HW :
% 1.Generate a QPSK sequence.
% 2.Upsample and pulse-shape the sequence(factor: eight).
% 3.add timing offset effect.
% 4.Implement the ZC recovery algorithm with the sampling phase selection
% method.
% 5.Adjust the parameters of the PLL and see its effect.
% 
%%
close all; clear all; clc;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Parameter                         
numBits = 50;                       % number of symbol
fs = numBits;                       % total of number of sampling point
multiple = 4;                       % sampling rate
cfo = 0.1;                          % Carrier frequency offset
n = linspace(-fs, fs,fs*2);         % sampling point interval
t = linspace(0,1,numBits*multiple);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% QPSK
bit_I = randi([0 1],numBits,1);             % Generate vector of 1bit binary data
bit_Q = randi([0 1],numBits,1);             % Generate vector of 1bit binary data
qpsk = gray_code(numBits,bit_I) + 1i*gray_code(numBits,bit_Q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Upsampling(TX)
qpsk_up = upsample(multiple,qpsk);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter(TX)
srrc_pulse = SRRC(0.1,n,multiple);
qpsk_srrc = conv(qpsk_up,srrc_pulse,'same');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Add CFO
qpsk_cfo = qpsk_srrc .* exp(1i * 2 * pi * cfo * t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sampling Frequency offset(STO)
sto=numBits;
qpsk_srrc_sto = resample(qpsk_srrc , length(qpsk_srrc)-sto , length(qpsk_srrc));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter(RX)
qpsk_rx = conv(qpsk_cfo,srrc_pulse,'same');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CR 
alpha = 0.01;
beta =  0.0001;
Ak_cr  = zeros(1, numBits);
qk_cr = zeros(1, numBits);
Ek_cr = zeros(1, numBits);
gk_cr = zeros(1, numBits);
sk_cr = zeros(1, numBits);
ck_cr = zeros(1, numBits);
phi_cr = zeros(1, numBits);

for a = 2:length(qpsk_rx)
    % decision detect
    qk_cr(a) = qpsk_rx(a) * exp(-1i * phi_cr(a-1));
    Ak_cr(a) = gray_code_reverse(1,real(qk_cr(a))) + i*gray_code_reverse(1,imag(qk_cr(a)));

    % phase detector
    Ek_cr(a) = angle((qk_cr(a)) * conj(Ak_cr(a)));

    % loop filter
    sk_cr(a) = (sk_cr(a-1) + (beta * Ek_cr(a))) ;
    gk_cr(a) = alpha * Ek_cr(a);
    ck_cr(a) = gk_cr(a) + sk_cr(a);
    
    % VCO
    phi_cr(a) = phi_cr(a-1) + ck_cr(a);
end
qk_cr(1) = qpsk_rx(1) * exp(-1i * phi_cr(length(qpsk_rx)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TR 
alpha = 0.001;
beta =  0.0001;
Ek = zeros(1, numBits);
sk = zeros(1, numBits);
gk = zeros(1, numBits);
ck = zeros(1, numBits);
tau = zeros(1, numBits);
output_tr = zeros(1, numBits);
rk = zeros(1, numBits);
idx = [round(1:length(qpsk_rx)/numBits:length(qpsk_rx)),length(qpsk_rx)];

for a = 1:numBits
    if( a > 1 )
        [rk output_tr(a)] = interpolation(multiple , idx(a) , qpsk_rx , tau(a-1));
    else
        [rk output_tr(a)] = interpolation(multiple , idx(a) , qpsk_rx , tau(a));
    end

    Ek(a) = zc(multiple , rk);  

    % loop filter
    if( a > 1 )
        sk(a) = sk(a-1) + (beta * Ek(a));
    else
        sk(a) = beta * Ek(a);
    end
    gk(a) = alpha * Ek(a);
    ck(a) = gk(a) + sk(a);
    if( a == 1 )
        tau(a) = ck(a);
    else
        tau(a) = tau(a-1) + ck(a);
    end

    if( a > 1 )
        output_tr(a) = rk(1);
    else
        [rk output_tr(a)] = interpolation(multiple , idx(a) , qpsk_rx , tau(a));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot
figure (1);
subplot(1, 2, 1);
plot(real(qpsk_rx), imag(qpsk_rx), 'o');  grid on;
title('QPSK with CFO');
subplot(1, 2, 2);
plot(real(qk_cr), imag(qk_cr), 'o'); grid on;
title('Recovered QPSK');

figure (2);
Y1 = [real(qpsk), imag(qpsk)];
Y2 = [real(output_tr), imag(output_tr)];
subplot(1, 1, 1); stem(Y1); hold on; stem(Y2); grid on;  legend('Tx','Rx'); 
