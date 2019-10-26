% Simular uma transmissão binária com os seguintes parâmetros:
% • Sequência de informação [0 1 1 0 1 0 1 1 0 1 0];
% • Sinalização NRZ unipolar com nível de amplitude de 1V;
% • Canal AWGN com SNR = 10 dB;
% • Recepção com e sem filtro casado (implementar as duas soluções)
% • Apresentar os gráficos de todos os estágios da transmissão, comentar e concluir os resultados;

pkg load communications; % Pacote para rodar no Octave

close all;
clear all;
clc;

N = 10;             % Fator de superamostragem, número de amostras por simbolo
M = 2;              % Número de níves de transmissão
l = log2(M);        % Quantidade de bits por nível de transmissão

t_final = 11;       % Tempo em segundos
Rb = 1;             % Taxa de transmissão
Rs = Rb/l;          % Taxa de transmissão de símbolos

fa = Rb*N;          % Frequência de amostragem
t = [0:(1/fa):t_final-(1/fa)];

% Sinalização 1
A = 1;            
limiar = A/2;
dist_nivel = A;   % Distância entre níveis

num_simb = Rs*t_final;

SNR = 10;

filtro_tx = ones(1,N);
filtro_rx = fliplr(filtro_tx); % Filtro casado na recepção

info_bin = [0 1 1 0 1 0 1 1 0 1 0];  % Informação binária que será transmitida
info_bin = reshape(info_bin, l, num_simb)';

info = bi2de(info_bin, 'left-msb')*dist_nivel;

info_up = upsample(info, N); % Adiciona N-1 amostras entre cada amostras de info

% Transmissão
info_tx = filter(filtro_tx, 1, info_up); % O filtro define o formato do sinal

% Recepção
info_rx = awgn(info_tx, SNR, 10*log10(A)); % Gera o ruído branco em função da variância SNR

% Sem filtro casado
info_hat_whithout_filter = info_rx(N : N : end) > limiar; % Infomarção estimada

% Com filtro casado
info_rx_filter = filter(filtro_rx, 1, info_rx)/N;
info_hat = info_rx_filter(N : N : end) > limiar; % Infomarção estimada

% ------------- SEM FILTRO CASADO

figure,
subplot(411)
stem(info_bin);
xlim([1 12])
xlabel('Tempo [s]');
ylabel('Bits');
title('Informação binária')

subplot(412)
plot(t, info_tx)
xlim([0 11])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação transmitida')

subplot(413)
plot(t, info_rx)
xlim([0 11])
ylim([-1 2])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação recebida')

subplot(414)
stem(info_hat_whithout_filter)
xlim([1 12])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação recebida estimada')

% ------------- COM FILTRO CASADO

figure,
subplot(511)
stem(info_bin);
xlim([1 12])
xlabel('Tempo [s]');
ylabel('Bits');
title('Informação binária')

subplot(512)
plot(t, info_tx)
xlim([0 11])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação transmitida')

subplot(513)
plot(t, info_rx)
xlim([0 11])
ylim([-1 2])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação recebida')

subplot(514)
plot(t, info_rx_filter)
xlim([0 11])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação recebida filtrada')

subplot(515)
plot(info_hat)
xlim([0 11])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação recebida filtrada e estimada')