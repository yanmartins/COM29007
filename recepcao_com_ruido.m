close all;
clear all;
clc;

N = 100;            % Fator de superamostragem
M = 2;              % Número de níves de transmissão
A = 1;              % Amplitude máxima
dist_nivel = A*2;   % Distância entre níveis
l = log2(M);        % Quantidade de bits por nível de transmissão
num_simb = 10;
%No_2 = 0.001;      % Quanto menor, menor será a potência do ruído
SNR = 0;           % Em dB
limiar = 0;

info_bin1 = randint(1, num_simb*l);
info_bin = reshape(info_bin1, l, num_simb)';

info = bi2de(info_bin, 'left-msb')*dist_nivel-A;

info_up = upsample(info, N); % Adiciona N-1 amostras entre cada amostras de info
filtro = ones(1,N);
info_tx = filter(filtro, 1, info_up); % O filtro define o formato do sinal

% ruido = sqrt(No_2)*randn(length(info_tx), 1);
% info_rx = info_tx + ruido;

info_rx = awgn(info_tx, SNR, 'measured'); % Gera o ruído branco em função da variância SNR
info_hat = info_rx(N/2 : N : end) > limiar; % Infomarção estimada

erros = sum(xor(info_bin1, info_hat'))
taxa_erro = erros/length(info_bin1)

figure(1)
subplot(311)
plot(info_tx)
xlim([0 num_simb*N])
ylim([-2 2])
title('Sinal transmitido')

subplot(312)
plot(info_rx)
xlim([0 num_simb*N])
ylim([-4 4])
title('Sinal recebido')

subplot(313)
stem(info_hat)
xlim([0 num_simb])
title('Sinal recebido (estimado)')
