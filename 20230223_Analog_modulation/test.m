% HW2
clear all
clc
%%
% 1.Implement a complex modulation system with real operations.
% (Let I-branch transmit a rectangular pulse and Q-branch a triangular pulse).
% refer to page.5
%%
%   Parameter
figure (1);
t = linspace(-1000, 0 ,1000);       %%  time
fs = 1/64;                          %%  x(t) frequency
fc = 1/4;                           %%  carrier frequency
carr_i = sqrt(2)*cos(2*pi*fc*t);    %%  carrier wave
carr_q = -sqrt(2)*sin(2*pi*fc*t);   %%  carrier wave
LPF=ones(1,4);                      %%  Low pass filter

%   I-branch:a rectangular pulse
m1 = square(2*pi*fs*t).*carr_i;
subplot(5,2,1);
plot(t,square(2*pi*fs*t));  title('rectangular pulse');  grid on;
subplot(5,2,2);
plot(t,m1);  title('m1(t)');  grid on;

%   Q-branch:a triangular pulse
m2 = sawtooth(2*pi*fs*t).*carr_q;
subplot(5,2,3);
plot(t,sawtooth(2*pi*fs*t));  title('triangular pulse');  grid on;
subplot(5,2,4);
plot(t,m2);  title('m2(t)');  grid on;

%   add m1, m2
yt=m1+m2;
subplot(5,2,5);
plot(t,yt);  title('y(t)');  grid on;

%   h()

%   y1
y1=yt.*carr_i;
subplot(5,2,7);
plot(t,yt);  title('y1(t)');  grid on;

%   y2
y2=yt.*carr_q;
subplot(5,2,8);
plot(t,yt);  title('y2(t)');  grid on;

%%Low pass filter
z1=conv(y1,LPF);
subplot(5,2,9);
plot(z1); title('LPF(y1(t)) and get m1(t)');   grid on;

%%Low pass filter
z2=conv(y2,LPF);
subplot(5,2,10);
plot(z2); title('LPF(y2(t)) and get m2(t)');   grid on;

%%
clear all
clc
%%
% 2.Implement a complex modulation system with complex operations.
% refer to page.7
%%
%   Parameter
figure (2);
t = linspace(-1000, 0 ,1000);       %%  time
fs = 1/64;                          %%  x(t) frequency
fc = 1/4;                           %%  carrier frequency
carr_i = sqrt(2)*cos(2*pi*fc*t);    %%  carrier wave
carr_q = -sqrt(2)*sin(2*pi*fc*t);   %%  carrier wave
LPF=ones(1,4);                      %%  Low pass filter

% Define signals m1(t) and m2(t)
m1 = square(2*pi*fs*t).*carr_i;
m2 = sawtooth(2*pi*fs*t).*carr_q;
subplot(4,2,1);
plot(t,square(2*pi*fs*t));  title('rectangular pulse');  grid on;
subplot(4,2,2);
plot(t,sawtooth(2*pi*fs*t));  title('triangular pulse');  grid on;
subplot(4,2,3);
plot(t,m1);  title('m1(t)');  grid on;
subplot(4,2,4);
plot(t,imag(1i*m2));  title('jm2(t)');  grid on;

% Convert to real   x(t)=Re{m1(t)+jm2(2)}
xt = real(m1) + imag(1i*m2);              % using "1i" instead of "j" to represent imaginary unit
yt=xt;

% y1(t),y2(t)
yt2=(yt.*carr_i) + 1i*(yt.*carr_q);
subplot(4,2,5);
plot(t,real(yt2));  title('y1(t)');  grid on;
subplot(4,2,6);
plot(t,imag(yt2));  title('jy2(t)');  grid on;

%%Low pass filter
z1=conv(yt2,LPF);
subplot(4,2,7);
plot(real(z1)); title('LPF(y(t)) and get m1(t)');   grid on;
subplot(4,2,8);
plot(imag(z1)); title('LPF(y(t)) and get jm2(t)');   grid on;


