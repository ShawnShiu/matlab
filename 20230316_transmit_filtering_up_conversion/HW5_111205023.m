% 20230316 Lab.5 Transmit Filtering / Up conversion
% Practice 2 :
% page 10
% 1.Generate a BPSK sequnce.
% 2.Conduct the SRRC pulse shaping operation with an upsampled factor of 8.
%
% Practice 3 :
% page 12
% 1.Using practice1,2, conduct the signal recovery in the receiver side. 
%%
close all; clear all; clc;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Parameter
T = 1;                          
numBits = 4;                    % number of symbol
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
t = zeros([total_point,fs]);
for x = 1 : total_point
    t(x,:) = t1 + T*x;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SRRC
srrc_pulse = SRRC(alpha,n,M);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% bpsk tx
bpsk = randi([0 1],1,numBits);      % binary
bpsk_enc = BPSK_enc(bpsk);
bpsk_up = upsample(multiple,bpsk_enc);
bpsk_srrc = bpsk_up.' .* srrc_pulse;      % combination SRRC


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Noise
[Eavg,sigma,noise] = AWGN(SNR,bpsk_enc,fs);
bpsk_tx = bpsk_srrc + noise;          % add to Tx signal


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% bpsk rx
for x = 1 : total_point
    filternoise(x,:) = filter(fir,bpsk_tx(x,:));        % filter Noise
end
bpsk_rx = filternoise .* srrc_pulse;                    % convolution SRRC
bpsk_down(:,:) = bpsk_rx(1:multiple:multiple*numBits,:);% Downsampling
for x = 1 : numBits
    Max = max(bpsk_down(x,:));
    Min = min(bpsk_down(x,:));
    if(abs(Max) >= abs(Min))
        bpsk_enc_rx(x) = Max;
    else
        bpsk_enc_rx(x) = Min;
    end
end
bpsk_dec = BPSK_dec(bpsk_enc_rx,1,-1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   BER
err_sym = compare_array(numBits,bpsk,bpsk_dec);
BER = err_sym/numBits


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot
figure (1);
subplot(4,2,1); plot(t1,srrc_pulse);        title('SRRC Pulse'); grid on;
subplot(4,2,2); plot(bpsk_enc,'o-');        title('BPSK 1=1,0=-1'); grid on;
subplot(4,2,3); plot(bpsk_up);              title('BPSK Upsample'); grid on;
subplot(4,2,4); hold on;                    title('BPSK SRRC (TX)'); grid on;
for x = 1 : total_point
    plot(t(x,:), bpsk_srrc(x,:));
end
subplot(4,2,5); hold on;                    title('BPSK SRRC+AWGN (TX)'); grid on;
for x = 1 : total_point
    plot(t(x,:), bpsk_tx(x,:));
end
subplot(4,2,6); hold on;                    title('Filter AWGN (RX)'); grid on;
for x = 1 : total_point
    plot(t(x,:), filternoise(x,:));
end
subplot(4,2,7); hold on;                    title('BPSK convolution SRRC (RX)'); grid on;
for x = 1 : total_point
    plot(t(x,:), bpsk_rx(x,:));
end
subplot(4,2,8); plot(bpsk_enc_rx,'o-');     title('BPSK 1=1,0=-1'); grid on; hold on;
plot(bpsk_enc,'x-');   

figure (2);
plot(bpsk_dec,'o-');     title('BPSK'); grid on; 
  
