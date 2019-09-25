close all;
clear all;
clc;

N = 10;            % Fator de superamostragem, número de amostras por simbolo
M = 2;              % Número de níves de transmissão
l = log2(M);        % Quantidade de bits por nível de transmissão

t_final = 1;        % tempo em segundos
Rb = 1e3;           % taxa de transmissão
Rs = Rb/l;    % taxa de transmissão de símbolos

fa = Rb*N;          % Frequência de amostragem
t = [0:(1/fa):t_final-(1/fa)];

% Sinalização 1
A = 1;              % Amplitude máxima
limiar = A/2;
dist_nivel = A*2;   % Distância entre níveis

num_simb = Rs*t_final;

SNR_min = 0;
SNR_max = 10;
SNR_vec = [SNR_min:SNR_max];

filtro_tx = ones(1,N);
filtro_rx = fliplr(filtro_tx);

info_bin = randi([0 1], 1, num_simb*l);
info_bin = reshape(info_bin, l, num_simb)';

info = bi2de(info_bin, 'left-msb')*dist_nivel- A;

info_up = upsample(info, N); % Adiciona N-1 amostras entre cada amostras de info
info_tx = filter(filtro_tx, 1, info_up); % O filtro define o formato do sinal

for SNR = SNR_min:SNR_max
    info_rx = awgn(info_tx, SNR-(log10(N))); % Gera o ruído branco em função da variância SNR
    info_rx_filter = filter(filtro_rx, 1, info_rx)/N;
    info_hat = info_rx_filter(N : N : end) > limiar; % Infomarção estimada
    
    num_erros(SNR + 1) = sum(xor(info_bin, info_hat));
    taxa_erro(SNR + 1) = num_erros(SNR + 1)/length(info_bin);
end

figure,
semilogy(SNR_vec, taxa_erro);
title('BER x SNR')
xlabel('SNR [dB]')
ylabel('Probabilidade de erro de bit')

figure,
subplot(311)
plot(t, info_tx)
xlim([0 10e-3])
ylim([-2 2])
title('Sinal transmitido')

subplot(312)
plot(t, info_rx)
xlim([0 10e-3])
ylim([-2 2])
title('Sinal recebido')

subplot(313)
plot(t, info_rx_filter)
xlim([0 10e-3])
title('Sinal recebido filtrado')