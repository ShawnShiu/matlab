%%
close all; clear all; clc;
%%

% Phase-Locked Loop (PLL) Example Code

% Define simulation parameters
fs = 100; % Sampling frequency
T = 1/fs; % Sampling period
t = 0:T:10-T; % Time vector
fc = 100; % Carrier frequency
Ac = 1; % Carrier amplitude
fm = 10; % Modulating frequency
Am = 0.5; % Modulating amplitude

% Generate modulating signal
m = Am*sin(2*pi*fm*t);

% Generate carrier signal
c = Ac*sin(2*pi*fc*t);

% Add modulating signal to carrier signal
s = c + m;

% Define PLL parameters
Kp = 1; % Proportional gain
Ki = 0.1; % Integral gain
Kd = 0.1; % Derivative gain
theta = zeros(size(t)); % Phase error
theta_dot = zeros(size(t)); % Phase error derivative
theta_int = zeros(size(t)); % Phase error integral
vco = zeros(size(t)); % VCO output
f = zeros(size(t)); % Instantaneous frequency estimate

% Loop through each sample in the input signal
for i = 2:length(t)
    
    % Calculate phase error
    theta(i) = angle(s(i)) - angle(vco(i-1));
    
    % Calculate phase error derivative
    theta_dot(i) = (theta(i) - theta(i-1))/T;
    
    % Calculate phase error integral
    theta_int(i) = theta_int(i-1) + theta(i)*T;
    
    % Calculate VCO output
    vco(i) = Ac*sin(2*pi*(fc+f(i))*t(i));
    
    % Calculate instantaneous frequency estimate
    f(i) = f(i-1) + Kp*theta(i) + Ki*theta_int(i) + Kd*theta_dot(i);
    
end

new = Ac*sin(2*pi.*f.*t);

% Plot input and output signals
figure(1);
subplot(2,1,1);
plot(t,s);
xlabel('Time (s)');
ylabel('Amplitude');
title('Input Signal');

subplot(2,1,2);
plot(t,new);
