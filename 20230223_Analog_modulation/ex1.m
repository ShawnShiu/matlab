%% RF link for Satellite Communications
clear 
clc
Giga=1.e+9;
Kilo=1.e+3;
%% input data
pt=10.0; % TX power
d=3.0;   % diameter for dish antenna
fcghz=12.0; % fc
nr=100;
eff=0.55;
rH=linspace(160*Kilo,1500*Kilo,nr);
%% pr
wavl=0.3/fcghz; % wavelength in meters
g=4*pi*(eff*pi*(d/2)^2)/wavl^2; % antenna gain
prH=pt*g*g*wavl^2/(4*pi)^2./rH.^2;
prdBmH=10*log10(prH*1000);
%% plot data
figure (1)
plot(rH/Kilo,prH)
grid on
xlabel('Range (Km)','fontsize',15)
ylabel('P_r (Watts)','fontsize',15)
%%
figure (2)
plot(rH/Kilo,prdBmH)
grid on
xlabel('Range (Km)','fontsize',15)
ylabel('P_r (dBm)','fontsize',15)