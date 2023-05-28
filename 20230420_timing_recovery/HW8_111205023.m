% 20230420 Lab.8 Timing recovery
% HW :
% page 18
% 1.Add sampling-frequency offset(SFO) to the received signal.
% 2.Let the upsampling factor to be two.
% 3.Implement the ZC recovery algorithm with the phase interpolation method.
% 4.Find the maximum SFO the ZC timing-recovery method can tolerate.
% 5.Add noise and see its influence to the performance(VS. SNR).
% 
%%
close all; clear all; clc;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Parameter                         
numBits = 20;                   % number of symbol
fs = 1000;                      % total of number of sampling point
n = linspace(-fs/2, fs/2, fs);  % sampling point interval
multiple = 4;                   % sampling rate
LPF=ones(1,4);                      %%  Low pass filter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% QPSK
bit_I = randi([0 1],numBits,1);             % Generate vector of 1bit binary data
bit_Q = randi([0 1],numBits,1);             % Generate vector of 1bit binary data
qpsk = gray_code(numBits,bit_I) + 1i*gray_code(numBits,bit_Q);
% qpsk = [1.0000 - 1.0000i  -1.0000 + 1.0000i   1.0000 + 1.0000i   1.0000 + 1.0000i  -1.0000 - 1.0000i  -1.0000 + 1.0000i   1.0000 - 1.0000i   1.0000 - 1.0000i   1.0000 + 1.0000i  -1.0000 + 1.0000i ...
% -1.0000 - 1.0000i  -1.0000 - 1.0000i   1.0000 - 1.0000i   1.0000 + 1.0000i  -1.0000 - 1.0000i  -1.0000 + 1.0000i  -1.0000 - 1.0000i  -1.0000 - 1.0000i  -1.0000 + 1.0000i  -1.0000 + 1.0000i];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Upsampling(TX)
qpsk_up = upsample(multiple,qpsk);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter(TX)
srrc_pulse = SRRC(0.1,n,multiple);
qpsk_srrc = conv(qpsk_up,srrc_pulse,'same');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Add Noise
SNR = 20;                           % SNR of dB
SignalPower=4*(1^2+1^2)/4;          % Avg SignalPower
sigma = SignalPower./(10.^(SNR./10));   % power of signal noise
noise_I =    (sigma/sqrt(2))*randn(1,numBits*multiple);
noise_Q = 1i*(sigma/sqrt(2))*randn(1,numBits*multiple);
qpsk_n = qpsk_srrc + noise_I + noise_Q;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sampling Frequency offset(SFO)
sto=numBits;
% qpsk_srrc_sto = resample(qpsk_srrc , length(qpsk_srrc)-sto , length(qpsk_srrc));
qpsk_srrc_sto = resample(qpsk_n , length(qpsk_n)-sto , length(qpsk_n));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter(RX)
qpsk_srrc_sto=conv(qpsk_srrc_sto,LPF);
qpsk_rx = conv(qpsk_srrc_sto,srrc_pulse,'same');

%% normalized
% qpsk_rx = real(qpsk_rx) * (max(srrc_pulse)/max(real(qpsk_rx))) +...
%       1i*(imag(qpsk_rx) * (max(srrc_pulse)/max(imag(qpsk_rx))));  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize PLL
alpha = 0.001;
beta =  0.0001;
Ek = zeros(1, numBits);
sk = zeros(1, numBits);
gk = zeros(1, numBits);
ck = zeros(1, numBits);
tau = zeros(1, numBits);
output = zeros(1, numBits);
rk = zeros(1, numBits);
idx = [round(1:length(qpsk_rx)/numBits:length(qpsk_rx)),length(qpsk_rx)];

for a = 1:numBits
    if( a > 1 )
        [rk output(a)] = interpolation(multiple , idx(a) , qpsk_rx , tau(a-1));
    else
        [rk output(a)] = interpolation(multiple , idx(a) , qpsk_rx , tau(a));
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
        output(a) = rk(1);
    else
        [rk output(a)] = interpolation(multiple , idx(a) , qpsk_rx , tau(a));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot
figure (1);
Y1 = [real(qpsk),imag(qpsk)];
Y2 = [real(output),imag(output)];
subplot(1, 1, 1); stem(Y1); hold on; stem(Y2); grid on; title('Real'); legend('Tx','Rx'); 
