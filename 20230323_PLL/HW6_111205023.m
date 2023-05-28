% 20230323 Lab.6 PLL
% Practice 1 :
% page 21
% 1.Implement the second-order filter shown on Page 15
% 
% Practice 2 :
% page 21
% 1.Implement a digital second-order PLL.
% 2.Assume that there is only a constant unknown phase.
% 3.Assume that there is an additional frequency offset.
% 4.Estimate the frequency offset.
% 5.Observe the PLL behavior with different patameter settings.
%%
%%
close all; clear all; clc;
%%
% Parameter
fs = 1e5;
N = 1e3;
f1 = 1e3;
Ts = 1/fs;
t = 0: Ts :(N-1)*Ts;
theta = linspace(0 , 60 , N);%0.05: 0.05 :50;
y = cos(2*pi*f1*t + theta);
alpha = 0.1;       % alph
beta =  0.001;       % beta

% init
VCO = zeros(1,N);
Phi = zeros(1,N);
sk = zeros(1,N);
error = zeros(1,N);

for n=2:N
    now_t = n*Ts;
    
    % phase detector
    ek(n) = y(n)*VCO(n-1);
    
    % loop filter
    gk = alpha*ek(n);
    sk(n) = sk(n-1) + beta*ek(n);
    ck = gk + sk(n);
    error(n) = ck;
    
    % VCO
    Phi(n) = Phi(n-1) - error(n);
    VCO(n) = 2*sin(2*pi*f1*now_t+Phi(n));
end

figure(1);
subplot(3,1,1);
plot(t,y,t,VCO); grid on; legend('In','VCO Out'); xlabel('time sec'); 
% plot(t,VCO); grid on; title('VCO Out'); xlabel('time sec'); 

txt = ['ck, alpha:',num2str(alpha),' beta:',num2str(beta)];
subplot(3,1,2);plot(error); grid on; title(txt);

subplot(3,1,3); plot(Phi); grid on; hold on;
plot(theta); legend('theta','Phi');

