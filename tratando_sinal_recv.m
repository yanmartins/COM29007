close all;
clear all;
clc;

N = 100;            % Fator de superamostragem, número de amostras por simbolo
M = 2;              % Número de níves de transmissão
l = log2(M);        % Quantidade de bits por nível de transmissão

t_final = 5;        % tempo em segundos
Rb = 1e3;           % taxa de transmissão
Rs = log2(M)/Rb;    % taxa de transmissão de símbolos

fa = Rb*N;          % Frequência de amostragem
t = [0:(1/fa):t_final];

A = 1;              % Amplitude máxima
dist_nivel = A*2;   % Distância entre níveis
num_simb = 5000;

SNR_min = 0;
SNR_max = 15;
SNR_vec = [SNR_min:SNR_max];

limiar = 0;

info_bin = randi([0 1], 1, num_simb*l);
info_bin = reshape(info_bin, l, num_simb)';

info = bi2de(info_bin, 'left-msb')*dist_nivel-A;

info_up = upsample(info, N); % Adiciona N-1 amostras entre cada amostras de info
filtro = ones(1,N);
info_tx = filter(filtro, 1, info_up); % O filtro define o formato do sinal

filtro_rx = fir1(50, (2*Rb)/fa);

for SNR = SNR_min:SNR_max
    info_rx = awgn(info_tx, SNR, 'measured'); % Gera o ruído branco em função da variância SNR
    info_hat = info_rx(N/2 : N : end) > limiar; % Infomarção estimada
    info_hat2 = filter(filtro_rx, 1, info_rx);
   
    num_erros(SNR + 1) = sum(xor(info_bin, info_hat));
    taxa_erro(SNR + 1) = num_erros(SNR + 1)/length(info_bin);
end


figure,
semilogy(SNR_vec, taxa_erro);hold on
title('BER x SNR')
xlabel('SNR [dB]')
ylabel('Probabilidade de erro de bit')

figure,
subplot(411)
plot(info_tx)
xlim([0 num_simb])
ylim([-2 2])
title('Sinal transmitido')

subplot(412)
plot(info_rx)
xlim([0 num_simb])
ylim([-4 4])
title('Sinal recebido')

subplot(413)
stem(info_hat)
xlim([0 num_simb/N])
title('Sinal recebido (estimado)')

subplot(414)
plot(info_hat2)
xlim([0 num_simb])
title('Sinal filtrado (estimado)')