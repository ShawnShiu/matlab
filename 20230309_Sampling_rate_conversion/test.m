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
clear all
clc
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
subplot(5,2,1);plot(t,wave_sin);  title('Sinusoidal Sample');  grid on;

%%  FFT
y = fftshift(fft(wave_sin));                    %%  fft
subplot(5,2,2);plot(abs(y));  title('Spectrum'); grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Downsample
Td = 1*multiple;                                %%  Cycle
td = linspace(0, Td ,fs);                       %%  frequency of sampling in first sec
dw_wave = downsample(multiple,wave_sin);
td2 = linspace(0, Td ,fs/2);
dw_wave2 = decimate(wave_sin,2);

subplot(5,2,3);plot(td,dw_wave);  title('Downsample');  grid on;

%%  FFT
yd = fftshift(fft(dw_wave));                    %%  fft
subplot(5,2,4);plot(abs(yd));  title('Spectrum'); grid on;

subplot(5,2,5);plot(td2,dw_wave2);  title('Downsample');  grid on;
yd = fftshift(fft(dw_wave2));                    %%  fft
subplot(5,2,6);plot(abs(yd));  title('Spectrum'); grid on;

