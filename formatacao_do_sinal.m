close all;
clear all;
clc;

N = 100;            % Fator de superamostragem
M = 2;              % Número de níves de transmissão
A = 5;              % Amplitude máxima
dist_nivel = A*2;   % Distância entre níveis
l = log2(M);        % Quantidade de bits por nível de transmissão
num_simb = 5000;
%No_2 = 0.001;      % Quanto menor, menor será a potência do ruído
SNR = 10;           % Em dB

info_bin = randint(1, num_simb*l);
info_bin = reshape(info_bin, l, num_simb)';

info = bi2de(info_bin, 'left-msb')*dist_nivel-A;

info_up = upsample(info, N); % Adiciona N-1 amostras entre cada amostras de info
filtro = ones(1,N);
info_tx = filter(filtro, 1, info_up); % O filtro define o formato do sinal

% ruido = sqrt(No_2)*randn(length(info_tx), 1);
% info_rx = info_tx + ruido;

info_rx = awgn(info_tx, SNR, 'measured');

figure(1)
subplot(211)
plot(info_tx)
xlim([0 20*N])

subplot(212)
plot(info_rx)
xlim([0 20*N])