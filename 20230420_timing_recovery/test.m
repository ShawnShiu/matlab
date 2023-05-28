% 20230420 Lab.8 carrier recovery
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
T = 1;                          
numBits = 8;                   % number of symbol
M = 100;                        % number of sampling point in a T(symbol)
fs = 1000;                      % total of number of sampling point
n = linspace(-fs/2, fs/2, fs);  % sampling point interval
interval = (T/M);
t1 = n*interval;
W = 1/(2*T);                    % BandWidth
SNR = 10;                       % SNR(dB)
alpha = 0.1;
multiple = 8;                   % sampling rate
total_point = numBits*multiple;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% create time array for every bit
% t = zeros([total_point,fs]);
% for x = 1 : total_point
%     t(x,:) = t1 + T*x;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SRRC
srrc_pulse = SRRC(alpha,n,M);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% QPSK + SRRC
bit_I=randi([0 1],numBits,1);             % Generate vector of 1bit binary data
bit_Q=randi([0 1],numBits,1);             % Generate vector of 1bit binary data
qpsk=gray_code(numBits,bit_I) + 1i*gray_code(numBits,bit_Q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Upsampling(TX)
qpsk_up = upsample(multiple,qpsk);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter(TX)
qpsk_srrc = conv(qpsk_up,srrc_pulse,'same');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sampling Timing offset(STO)
qpsk_srrc_sto = qpsk_srrc;
sto=7;
for x = 1 : sto
    qpsk_srrc_sto(:, x*multiple) = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter(RX)
qpsk_srrc_filter = conv(qpsk_srrc_sto,srrc_pulse,'same');
%% normalized
qpsk_srrc_filter = real(qpsk_srrc_filter) * (max(srrc_pulse)/max(real(qpsk_srrc_filter))) +...
               1i*(imag(qpsk_srrc_filter) * (max(srrc_pulse)/max(imag(qpsk_srrc_filter))));  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize PLL
alpha = 0.001;
beta =  0.0001;
rk = zeros(1, length(qpsk_srrc_filter));
output  = zeros(1, length(qpsk_srrc_filter));
qk = zeros(1, length(qpsk_srrc_filter));
Ek = zeros(1, length(qpsk_srrc_filter));
gk = zeros(1, length(qpsk_srrc_filter));
sk = zeros(1, length(qpsk_srrc_filter));
ck = zeros(1, length(qpsk_srrc_filter));
tau = zeros(1, length(qpsk_srrc_filter));

for a = 1:length(qpsk_srrc_filter)
    if( a ==1 )

    else

    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot
figure (1);
subplot(2,1,1); 
Y = [real(qpsk_srrc_filter), imag(qpsk_srrc_filter)];
stem(Y);

Y = [real(qpsk_srrc), imag(qpsk_srrc)];
subplot(2,1,2); 
stem(Y);

% subplot(4,2,1); title('QPSK (TX)'); grid on;
% plot(real(qpsk),imag(qpsk), 'o'); grid on;
% subplot(4,2,2); title('QPSK (RX)'); grid on;
% plot(real(output),imag(output), 'o'); grid on;
% for x = 1 : total_point
%     plot(real(qpsk_srrc(x,:)),imag(qpsk_srrc(x,:)),'o');
% end


