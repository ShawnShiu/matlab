%%
clc; close all; clear all;
%%
%% parameter
numbit = 500;
multiple = 8;

%% QPSK modulation
qpsk_m = comm.QPSKModulator('BitInput',true);
data = randi([0 1],numbit*2,1);
txSig = qpsk_m(data);

%% SRRC + Upsample
txfilter = comm.RaisedCosineTransmitFilter('Gain',1.5,'OutputSamplesPerSymbol',multiple);
txSig = txfilter(txSig);

%% CFO
cfo = comm.PhaseFrequencyOffset('FrequencyOffset',1e1,'PhaseOffset',10,'SampleRate',1e9);
txSig = cfo(txSig);

%% STO
sto = dsp.VariableFractionalDelay;
delay = (0:1/((numbit*multiple)):1-1/((numbit*multiple)))';
txSig = sto(txSig,delay);

%% channel
ch = comm.AWGNChannel('EbNo',20);
txSig = ch(txSig);

%% SRRC
rxfilter = comm.RaisedCosineReceiveFilter("InputSamplesPerSymbol",1,"DecimationFactor",1);
rxSig = rxfilter(txSig);

%% TR
symbolSync = comm.SymbolSynchronizer('TimingErrorDetector','Zero-Crossing (decision-directed)',...
                                     'SamplesPerSymbol',multiple, ...
                                     'NormalizedLoopBandwidth',0.035);
rxSig_tr = symbolSync(rxSig);

%% CR
carrierSync = comm.CarrierSynchronizer( 'NormalizedLoopBandwidth',0.005,...
                                        'SamplesPerSymbol',1, ...
                                        'Modulation','QPSK');
rxSig_cr = carrierSync(rxSig_tr);

%% plot
figure(1);
subplot(1,3,1);
plot(real(rxSig),imag(rxSig),'.'); grid on; title('rx');
subplot(1,3,2);
plot(real(rxSig_tr),imag(rxSig_tr),'.'); grid on; title('tr');
subplot(1,3,3);
plot(real(rxSig_cr),imag(rxSig_cr),'.'); grid on; title('cr');
scatterplot(rxSig_cr);
