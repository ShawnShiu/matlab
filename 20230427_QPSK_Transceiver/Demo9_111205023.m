% 20230423 Lab.9 carrier recovery
% Practice 1 :
% page 17
% 1.Generate a QPSK sequence.
% 2.write a channel model with CFO STO and noise added
% 3.Design the receiver to recover the QPSK signal.
% 4.Use the ZC TR method combined with DD CR to recovery the transmit
% symbols.
% 5.Use Gardner's TR method combined with DD CR to recovery the transmit
% symbols.
% 
%%
close all; clear all; clc;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Parameter                         
numBits = 50;                   % number of symbol
fs = 1000;                      % total of number of sampling point
n = linspace(-fs, fs, fs);  % sampling point interval
multiple = 8;                   % sampling rate
cfo = 10;          % Carrier frequency offset

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
%% Add Noise
% SNR = 10;                           % SNR of 10 dB
% SignalPower=4*(1^2+1^2)/4;          % Avg SignalPower
% sigma = SignalPower./(10.^(SNR./10));   % power of signal noise
% noise_I =    (sigma/sqrt(2))*randn(1,numBits*multiple);
% noise_Q = 1i*(sigma/sqrt(2))*randn(1,numBits*multiple);
qpsk_n = qpsk_srrc ;%+ noise_I + noise_Q;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sampling Timing offset(STO)
sto=numBits;
qpsk_srrc_sto_cfo = qpsk_n;
for x = 1 : (sto-1)
    qpsk_srrc_sto_cfo((x*multiple)-x) = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Add CFO
t = linspace(-length(qpsk_srrc_sto_cfo),length(qpsk_srrc_sto_cfo),length(qpsk_srrc_sto_cfo));
qpsk_cfo = qpsk_srrc_sto_cfo .* exp(1i * 2 * pi * cfo * t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter(RX)
qpsk_rx = conv(qpsk_cfo,srrc_pulse,'same');

%% normalized
% qpsk_rx = real(qpsk_rx) * (max(srrc_pulse)/max(real(qpsk_rx))) +...
%       1i*(imag(qpsk_rx) * (max(srrc_pulse)/max(imag(qpsk_rx))));  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize PLL
alpha = 0.001;
beta =  0.0001;
alpha_cr = 0.001;
beta_cr =  0.0001;
Ek = zeros(1, numBits);
sk = zeros(1, numBits);
gk = zeros(1, numBits);
ck = zeros(1, numBits);
tau = zeros(1, numBits);
output_tr = zeros(1, numBits);
rk = zeros(1, numBits);
idx = [round(1:length(qpsk_rx)/numBits:length(qpsk_rx)),length(qpsk_rx)];
qk_cr = zeros(1, numBits);
phi_k = zeros(1, numBits);
Ak_cr = zeros(1, numBits);
Ek_cr = zeros(1, numBits);
sk_cr = zeros(1, numBits);
gk_cr = zeros(1, numBits);
ck_cr = zeros(1, numBits);

for a = 1:numBits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TR
    if( a > 1 )
        rk = phase_select(multiple , idx(a) , qpsk_rx , tau(a-1));
    else
        rk = phase_select(multiple , idx(a) , qpsk_rx , tau(a));
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
        rk = phase_select(multiple , idx(a) , qpsk_rx , tau(a));
        output_tr(a) = rk(1);
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CR
    if( a > 1 )
        % decision detect
        qk_cr(a) = output_tr(a) * exp(-1i * phi_k(a-1));
        Ak_cr(a) = gray_code_reverse(1,real(qk_cr(a))) + i*gray_code_reverse(1,imag(qk_cr(a)));

        % phase detector
        Ek_cr(a) = angle((qk_cr(a)) * conj(Ak_cr(a)));

        % loop filter
        sk_cr(a) = (sk_cr(a-1) + (beta_cr * Ek_cr(a))) ;
        gk_cr(a) = alpha_cr * Ek_cr(a);
        ck_cr(a) = gk_cr(a) + sk_cr(a);

        % VCO
        phi_k(a) = phi_k(a-1) + ck_cr(a);
    end
end
qk_cr(1) = output_tr(1) * exp(-1i * phi_k(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot
figure (1);
Y1 = [real(qpsk),imag(qpsk)];
Y2 = [real(output_tr),imag(output_tr)];
subplot(1, 1, 1); stem(Y1); hold on; stem(Y2); grid on; title('Real'); legend('Tx','Rx'); 
scatterplot(output_tr);
scatterplot(qk_cr);
