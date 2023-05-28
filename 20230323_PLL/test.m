%%
close all; clear all; clc
%%
% Parameter
fs = 7e5;
N = 1e3;
f1 = 7e3;
fvco = 8e3;
pvco = 4e3;
fc = 3e3;
coef = 120;
bpf = fir1(coef , fc/(fs/2));
Ts = 1/fs;
t = 0:Ts:(N-1)*Ts;
theta = 0.05:0.05:50;
y = cos(2*pi*f1*t+theta);

% init
VCO = zeros(1,N);
Phi = zeros(1,N);
sk = zeros(1,N);
error = zeros(1,N);
a1 = 0.01;     % alph
a2 = 0.001;    % beta

for n=2:N
   now_t = n*Ts;
   
   % phase detector
   ek(n) = y(n)*VCO(n-1);

   % loop filter
   gk = a1*ek(n);
   sk(n) = sk(n-1) + a2*ek(n);
   ck = gk+sk(n);
   error(n) = ck;
   
%    for m=1 : length(bpf)
%         if (n-m+1) > 1
%             error_array(m) = ek(n-m+1);
%         else
%             error_array(m) = 0;
%         end
%    end
%    error(n) = sum(error_array.*(bpf));
   
   % VCO
%    Phi(n) = Phi(n-1) + 2*pi*pvco*error(n)*Ts;
Phi(n) = Phi(n-1) - error(n);

   VCO(n) = 2*sin(2*pi*f1*now_t+Phi(n));
end

figure(1);
plot(t,y,t,VCO); grid on; legend('In','out'); xlabel('time sec'); 

% figure(2);
% subplot(2,1,1);plot(ek); grid on;  title('ek');
% subplot(2,1,2);plot(error); grid on;  title('ck');

figure(3);
subplot(2,1,1); plot(Phi); grid on;     title('Phi'); hold on;
 plot(theta); 

