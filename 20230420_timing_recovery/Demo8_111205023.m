% 20230420 Lab.8 Timing recovery
% Practice 1 :
% page 17
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
numBits = 500;                   % number of symbol
fs = 1000;                      % total of number of sampling point
n = linspace(-fs/2, fs/2, fs);  % sampling point interval
multiple = 8;                   % sampling rate

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
%% Sampling Timing offset(STO)
sto=numBits;
qpsk_srrc_sto = qpsk_srrc;
for x = 1 : (sto)
    qpsk_srrc_sto((x*multiple)-x) = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter(RX)
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
        output(a) = rk(1);
    else
        rk = phase_select(multiple , idx(a) , qpsk_rx , tau(a));
        output(a) = rk(1);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot
figure (1);
Y1 = [real(qpsk),imag(qpsk)];
Y2 = [real(output),imag(output)];
subplot(1, 1, 1); stem(Y1); hold on; stem(Y2); grid on; title('Real'); legend('Tx','Rx'); 
