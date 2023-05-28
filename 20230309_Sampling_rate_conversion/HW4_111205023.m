% 20230309 Lab.4 Sampling and rate conversion
% Practice 2 :
% page 12 & 16h
% 1.Generate a signal with two sinusoidal signals;downsample the
%   signal(without aliasing),and then upsample the downsampled signal
% 2.Design an FIR LPF and let the upsampled signal pass the filter such
%   that the upsampled signal is similar to the original signel
% 3.Design an IIR LPF 
% 4.Calculate the MSE of these two interpolated results.
%%
close all; clear all; clc;
%%
%   Parameter
multiple = 2;
f1 = 100;                                       %%  frequency 1
f2 = 200;                                       %%  frequency 2
fs = 1024;                                      %%  frequency of sampling

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Sinusoidal
T = 1;                                          %%  Cycle
t = linspace(0, T ,fs);                         %%  frequency of sampling in first sec
wave_sin = sin(2*pi*f1*t) + sin(2*pi*f2*t);     %%  carrier wave
figure(1);
subplot(6,2,1);plot(t,wave_sin);  title('Wave (100+200Hz)');  grid on;

%%  FFT
y = fftshift(fft(wave_sin));                    %%  fft
subplot(6,2,2);plot(abs(y));  title('Spectrum'); grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  LPF
lpf_wave=lowpass(wave_sin,100,fs);
y_lpf = fftshift(fft(lpf_wave));
subplot(6,2,3);plot(t,lpf_wave);   title('LPF wave (100Hz)');  grid on;
subplot(6,2,4);plot(abs(y_lpf));   title('Spectrum');  grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Downsample
Td = 1*multiple;                                %%  Cycle
td = linspace(0, Td ,fs);                       %%  frequency of sampling in first sec
% dw_wave = downsample(multiple,wave_sin);
dw_wave = downsample(multiple,lpf_wave);
subplot(6,2,5);plot(td,dw_wave);  title('Downsample');  grid on;

%%  FFT
yd = fftshift(fft(dw_wave));                    %%  fft
subplot(6,2,6);plot(abs(yd));  title('Spectrum'); grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Upsample
Tu = 1*multiple;                                %%  Cycle
tu = linspace(0, Tu ,fs*multiple);              %%  frequency of sampling in first sec
up_wave = upsample(multiple,dw_wave);
subplot(6,2,7);plot(tu,up_wave);  title('Upsample');  grid on;

%%  FFT
yu = fftshift(fft(up_wave));                    %%  fft
subplot(6,2,8);plot(abs(yu));  title('Spectrum'); grid on;

%% FIR
fir_wave=filter(fir_window,up_wave);
y_fir = fftshift(fft(fir_wave));
subplot(6,2,9);plot(tu,fir_wave);   title('FIR_window');  grid on;
subplot(6,2,10);plot(abs(y_fir));   title('Spectrum');  grid on;

%% IIR
iir_wave=filter(iir_butterworth,up_wave);
y_iir = fftshift(fft(iir_wave));
subplot(6,2,11);plot(tu,iir_wave);   title('IIR_window');  grid on;
subplot(6,2,12);plot(abs(y_iir));   title('Spectrum');  grid on;

%% Mean squared error (MSE)
mse_fir = immse(lpf_wave, fir_wave(1:fs));
mse_iir = immse(lpf_wave, iir_wave(1:fs));
fprintf('\n The FIR mean-squared error is %0.4f\n', mse_fir);
fprintf('\n The IIR mean-squared error is %0.4f\n', mse_iir);
