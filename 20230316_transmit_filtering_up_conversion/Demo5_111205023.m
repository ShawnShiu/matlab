% 20230316 Lab.5 Transmit Filtering / Up conversion
% Practice 1 :
% page 7
% 1.Plot a sampled RC pulse and see its spectrum
% 2.Plot a SRRC pulse and see its spectrum then change it to function
% 3.Check if the convolution of a SRRC pulse and another SRRC pulse will
%   give you a RC pulse
%%
close all; clear all; clc;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Parameter
T = 1;                          % number of symbol
M = 100;                        % number of sampling point in a T(symbol)
fs = 1000;                      % total of number of sampling point
n = linspace(-fs/2, fs/2, fs);  % sampling point interval
t_inv = n*(T/M);                % time interval
W = 1/(2*T);                    % BandWidth
alpha = 0.1;                   
f_inv = linspace(-fs/2, fs/2, fs);  % freq interval

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RC
rc_pulse = RC(alpha,W,t_inv);

%%  FFT
y_RC = fftshift(fft(rc_pulse));                    %%  fft


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SRRC
srrc_pulse = SRRC(alpha,n,M);

%%  FFT
y_SRRC = fftshift(fft(srrc_pulse));                    %%  fft


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SRRC to RC
check_srrc = conv(srrc_pulse, srrc_pulse, 'same');
check_srrc = check_srrc * (max(rc_pulse)/max(check_srrc));  %% normalized

%%  FFT
y_SRRC_check = fftshift(fft(check_srrc));                    %%  fft


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot
figure (1);
% RC
subplot(3,2,1); plot(t_inv, rc_pulse);  title('RC Pulse'); grid on;
subplot(3,2,2); plot(f_inv,abs(y_RC));  title('Spectrum'); grid on;
% SRRC
subplot(3,2,3); plot(t_inv,srrc_pulse);     title('SRRC Pulse'); grid on;
subplot(3,2,4); plot(f_inv,abs(y_SRRC));    title('Spectrum'); grid on;
% SRRC to RC
subplot(3,2,5); plot(t_inv, check_srrc);        title('SRRC to RC Pulse'); grid on;
subplot(3,2,6); plot(f_inv,abs(y_SRRC_check));  title('Spectrum'); grid on; 
figure (2);
% Check 
subplot(2,1,1); plot(t_inv, check_srrc);        title('RC Pulse'); grid on; hold on; plot(t_inv,rc_pulse,'o');   
subplot(2,1,2); plot(f_inv,abs(y_SRRC_check));  title('Spectrum'); grid on; hold on; plot(f_inv,abs(y_SRRC_check),'o');
