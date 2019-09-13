close all;
clear all;
clc;

N = 100;    % Fator de superamostragem
M = 8;      % Número de níves de transmissão
l = log2(M); % Quantidade de bits por nível de transmissão
num_simb = 5000;

info_bin = randint(1, num_simb*l);
info_bin = reshape(info_bin, l, num_simb)';

info = bi2de(info_bin, 'left-msb')*2-(M-1);

info_up = upsample(info, N); % Adiciona N-1 amostras entre cada amostras de info
filtro = ones(1,N);
info_tx = filter(filtro, 1, info_up); % O filtro define o formato do sinal

figure(1)
plot(info_tx)
xlim([0 20*N])