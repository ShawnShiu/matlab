% 20230309 Lab.4 Sampling and rate conversion
% Practice 1 :
% page 12 & 16
% 1.Generate a sinusoidal signal, downsample the signal and observe the its
%   specturm
% 2.Determine the maximum downsampling rate such that the aliasing will not
%   occur
% 3.Then upsample the downsampled signal, and observe its spectrum.
%%
close all; clear all; clc;
%%
%   Parameter
multiple = 2;
f = 20;                                          %%  frequency
fs = 1024;                                       %%  frequency of sampling

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Sinusoidal
T = 1;                                          %%  Cycle
t = linspace(0, T ,fs);                         %%  frequency of sampling in first sec
wave_sin = sin(2*pi*f*t);                       %%  carrier wave
subplot(3,2,1);plot(t,wave_sin);  title('Sinusoidal Sample');  grid on;

%%  FFT
y = fftshift(fft(wave_sin));                    %%  fft
subplot(3,2,2);plot(abs(y));  title('Spectrum'); grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Downsample
Td = 1*multiple;                                %%  Cycle
td = linspace(0, Td ,fs);                       %%  frequency of sampling in first sec
dw_wave = downsample(multiple,wave_sin);
subplot(3,2,3);plot(td,dw_wave);  title('Downsample');  grid on;

%%  FFT
yd = fftshift(fft(dw_wave));                    %%  fft
subplot(3,2,4);plot(abs(yd));  title('Spectrum'); grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Upsample
Tu = 1*multiple;                                %%  Cycle
tu = linspace(0, Tu ,fs*multiple);                       %%  frequency of sampling in first sec
up_wave = upsample(multiple,dw_wave);
subplot(3,2,5);plot(tu,up_wave);  title('Upsample');  grid on;

%%  FFT
yu = fftshift(fft(up_wave));                    %%  fft
subplot(3,2,6);
plot(abs(yu));  title('Spectrum'); grid on;

