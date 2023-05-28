% 20230223 Lab.2 Analog_modulation
% Practice 1 :
% page 3
% 1.Generate a sinusoidal signal with freq of 1/64 and a carrier with freq
% of 1/4
% 2.Design a LPF(with an averaging filter).
% 3.generate a triangular pulse with the duration of 64 and coduct the
% modulation and demodulation again.
close all; clear all; clc;
%%
fs = 1/64;                          %%  x(t) frequency
fc = 1/4;                           %%  carrier frequency
t = linspace(-1000, 0 ,1000);       %%  time

%%x(t)
xt = cos(2*pi*fs*t);
subplot(2,3,1);
plot(t,xt); title('x(t)');  grid on;

%%x(t) is triangle
% t2=linspace(0, 100 ,20000);
% xt2 = sawtooth(t2);
% subplot(2,3,1);
% plot(t2,xt2);

%%carrier wave
c = cos(2*pi*fc*t);
subplot(2,3,2);
plot(t,c);  title('carrier wave');  grid on;

%%y(t)
yt = xt.*c;         %%mixer
subplot(2,3,3);
plot(t,yt); title('y(t)');  grid on;

%%z(t)
zt = yt.*c;         %%mixer
subplot(2,3,4);
plot(t,zt); title('z(t)');  grid on;

%%Low pass filter
LPF=ones(1,10);
xt_r=conv(zt,LPF);
subplot(2,3,5);
plot(xt_r); title('xt_r(t)');   grid on;
