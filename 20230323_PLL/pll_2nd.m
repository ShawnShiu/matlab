%%
close all; clear all; clc;
%%

%% Second-Order Phase-Locked Loop (PLL) Example

% Define constants
Fs = 10000;         % Sampling frequency
Fc = 1e3;           % Carrier frequency
Fr = 1e3+90;        % Reference frequency
N = 2;              % Order of the loop filter
BW = 2e3;           % Loop filter bandwidth
T = 1/Fs;           % Sampling period
t = 0: T :1/Fc;     % Time vector
L = length(t);      % Length of the time vector

% Generate carrier and reference signals
carrier = cos(2*pi*Fc*t);
reference = 2*sin(2*pi*Fr*t);

% Initialize PLL variables
theta = 0;         % Initial phase estimate
phi = 0;           % Initial frequency estimate
integ = 0;         % Integrator output
deriv = 0;         % Differentiator output
VCO = zeros(1,L);
Phi = zeros(1,L);
error = zeros(1,L);

% Loop filter coefficients
% a1 = 2*pi*BW*T;
% a2 = (2*pi*BW*T)^2;
a1 = 0.01;      % alph
a2 = 0.001;    % beta

% Phase-locked loop
for n = 1:L
    now_t = n*T;
    % Phase detector
    error(n) = reference(n)*cos(theta) - carrier(n)*sin(theta);
    
    % Loop filter
    integ = integ + error(n);
    deriv = error(n) - phi;
    if N == 1
        filter_out = integ;
    else
        filter_out = a1*integ - a2*deriv;
    end
    
    % Voltage-controlled oscillator (VCO)
    phi = phi + filter_out;
    
    % Phase accumulator
    theta = theta + phi*T + error(n);
    
    % Output
    output(n) = theta;
    
   % VCO
   Phi(n) = phi;
   VCO(n) = sin(2*pi*Fc*now_t+phi);
end


% Plot results
figure (1);
plot(t, carrier, 'b-', t, VCO, 'r--');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Carrier', 'VCO');
title('PLL Input Signals');

figure (2);
plot(output);

figure (3);
plot(error);
