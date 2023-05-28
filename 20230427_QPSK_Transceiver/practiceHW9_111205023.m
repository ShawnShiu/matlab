%%
close all; clear all; clc;
%%
%%  Parameter                         
numBits = 500;                       % number of symbol
multiple = 8;                       % sampling rate

%% QPSK
qpskModulator = comm.QPSKModulator('BitInput',true);
data = randi([0 1],numBits*2,1);
txSig = qpskModulator(data);
qpsk_t = txSig;

%% Add CFO
pfo = comm.PhaseFrequencyOffset('PhaseOffset',1, ...
                                'FrequencyOffset',1e1, ...
                                'SampleRate',1e9);
txSig = pfo(txSig);

%% srrc+up
txfilter = comm.RaisedCosineTransmitFilter('Gain',1.5,...
                                           'OutputSamplesPerSymbol',multiple);
txSig = txfilter(txSig);

%% STO
varDelay = dsp.VariableFractionalDelay;
vdelay = ((0:1/(numBits*multiple):1-1/(numBits*multiple))');   
txSig = varDelay(txSig,vdelay);

%%%%%%%%%%%%%%%%%%%%%%%%%%% channel
channel = comm.AWGNChannel('EbNo',15);
txSig = channel(txSig);
%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% rx srrc
rxfilter = comm.RaisedCosineReceiveFilter('Gain',1.5,...
                                          'InputSamplesPerSymbol',multiple, ...
                                          'DecimationFactor',multiple/2);
rxSig = rxfilter(txSig);

%% CR
carrierSync = comm.CarrierSynchronizer( 'NormalizedLoopBandwidth',0.005,...
                                        'SamplesPerSymbol',1, ...
                                        'Modulation','QPSK');
rxSig_cr = carrierSync(rxSig);

%% TR
symbolSync = comm.SymbolSynchronizer('TimingErrorDetector','Zero-Crossing (decision-directed)',...
                                     'SamplesPerSymbol',2, ...
                                     'NormalizedLoopBandwidth',0.035);
rxSig = symbolSync(rxSig_cr);

%% plot
figure (1);
subplot(1, 2, 1);
plot(real(rxSig_cr), imag(rxSig_cr), 'o'); title('cr');  grid on;
subplot(1, 2, 2);
plot(real(rxSig), imag(rxSig), 'o'); title('tr');  grid on;
scatterplot(rxSig);
