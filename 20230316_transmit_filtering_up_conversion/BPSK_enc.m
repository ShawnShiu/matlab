function bpsk = BPSK_enc(bpsk_bits)
    bpsk = 2*bpsk_bits - 1;                  % Convert to 1 or -1
end

% 
% 
% %%  Parameter
% sec = 1;            % second
% numBits = 4;     % number of bits
% amp = 1;            % amplitude of the carrier signal
% fc = 10^6;          % carrier frequency (in Hertz)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%  BPSK
% bits = randi([0 1],1,numBits);      % binary
% bpskSeq = 2*bits - 1;               % Convert to 1 or -1
% t = linspace(0,sec,numBits);        % time
% carrier = amp * cos(2*pi*fc*t);     % carrier
% bpskSignal = bpskSeq .* carrier;    % BPSK signal
% 
% figure (1)
% subplot(6,2,1);plot(t,bpskSignal); xlabel('Time (s)'); ylabel('Amplitude'); title('BPSK Signal');
