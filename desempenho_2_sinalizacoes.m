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

% Sinalização 1
A = 1;              % Amplitude máxima
limiar = 0;
dist_nivel = A*2;   % Distância entre níveis

% Sinalização 2
A_dois = A*sqrt(2);
limiar2 = A_dois/2;
dist_nivel2 = A_dois;   % Distância entre níveis

num_simb = 5000;

SNR_min = 0;
SNR_max = 15;
SNR_vec = [SNR_min:SNR_max];

info_bin = randi([0 1], 1, num_simb*l);
info_bin = reshape(info_bin, l, num_simb)';

info = bi2de(info_bin, 'left-msb')*dist_nivel - A;
info2 = bi2de(info_bin, 'left-msb')*A_dois;

info_up = upsample(info, N); % Adiciona N-1 amostras entre cada amostras de info
info_up2 = upsample(info2, N); % Adiciona N-1 amostras entre cada amostras de info

filtro = ones(1,N);
info_tx = filter(filtro, 1, info_up); % O filtro define o formato do sinal
info_tx2 = filter(filtro, 1, info_up2); % O filtro define o formato do sinal

for SNR = SNR_min:SNR_max
    info_rx = awgn(info_tx, SNR, 10*log10(A)); % Gera o ruído branco em função da variância SNR
    info_rx2 = awgn(info_tx2, SNR, 10*log10(A_dois)); % Gera o ruído branco em função da variância SNR
    
    info_hat = info_rx(N/2 : N : end) > limiar; % Infomarção estimada
    info_hat2 = info_rx2(N/2 : N : end) > limiar2; % Infomarção estimada
    
    num_erros(SNR + 1) = sum(xor(info_bin, info_hat));
    taxa_erro(SNR + 1) = num_erros(SNR + 1)/length(info_bin);
    
    num_erros2(SNR + 1) = sum(xor(info_bin, info_hat2));
    taxa_erro2(SNR + 1) = num_erros2(SNR + 1)/length(info_bin);
end

figure,
semilogy(SNR_vec, taxa_erro);hold on
semilogy(SNR_vec, taxa_erro2);
title('BER x SNR')
xlabel('SNR [dB]')
ylabel('Probabilidade de erro de bit')
legend('Sinalização 1', 'Sinalização 2')

figure,
subplot(311)
plot(info_tx)
xlim([0 num_simb])
ylim([-2 2])
title('Sinal transmitido')

subplot(312)
plot(info_rx)
xlim([0 num_simb])
ylim([-4 4])
title('Sinal recebido')

subplot(313)
stem(info_hat)
xlim([0 num_simb/N])
title('Sinal recebido (estimado)')

figure,
subplot(311)
plot(info_tx2)
xlim([0 num_simb])
ylim([-2 2])
title('Sinal transmitido')

subplot(312)
plot(info_rx2)
xlim([0 num_simb])
ylim([-4 4])
title('Sinal recebido')

subplot(313)
stem(info_hat2)
xlim([0 num_simb/N])
title('Sinal recebido (estimado)')
