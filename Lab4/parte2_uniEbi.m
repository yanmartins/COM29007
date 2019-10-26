close all;
clear all;
clc;

N = 10;             % Fator de superamostragem, número de amostras por simbolo
M = 2;              % Número de níves de transmissão
l = log2(M);        % Quantidade de bits por nível de transmissão

t_final = 11;       % tempo em segundos
Rb = 50000;         % taxa de transmissão
Rs = Rb/l;          % taxa de transmissão de símbolos
fa = Rb*N;          % Frequência de amostragem

% Sinalização 1
A1 = 1;

limiar1 = A1/2;
limiar2 = 0; 

num_simb = Rs*t_final;

SNR_max = 10;

filtro_tx = ones(1,N);
filtro_rx = fliplr(filtro_tx); % Filtro casado na recepção

info = randint(1, Rb);  % Informação binária que será transmitida

##info_nrz1 = info * A1;
##info_nrz2 = (info*2*A1) - A1;

info_up = upsample(info, N); % Adiciona N-1 amostras entre cada amostras de info

% Transmissão
info_tx1 = filter(filtro_tx, 1, info_up)* A1; % O filtro define o formato do sinal
info_tx2 = filter(filtro_tx, 1, info_up)*(2*A1) - A1;

% Verificação de erro em função da SNR
for SNR = 0 : SNR_max
    % Recepção
    info_rx1 = awgn(info_tx1, SNR - (10*log10(A1))); % Gera o ruído branco em função da variância SNR
    info_rx2 = awgn(info_tx2, SNR - (10*log10(2*A1)));
    
    info_rx_filter1 = filter(filtro_rx, 1, info_rx1)/N;
    info_hat1 = info_rx_filter1(N : N : end) > limiar1; % Informação estimada
    
    info_rx_filter2 = filter(filtro_rx, 1, info_rx2)/N;
    info_hat2 = info_rx_filter2(N : N : end) > limiar2; % Informação estimada
    
    % Probabilidade de erro de bit do sinal Rx
    Pb1(SNR+1) = sum(xor(info,info_hat1))/length(info_hat1);
    Pb2(SNR+1) = sum(xor(info,info_hat2))/length(info_hat2);
end

% Plotando os resultados
figure, 
semilogy([0:SNR_max],Pb1); hold on;
semilogy([0:SNR_max],Pb2);
xlabel('SNR');
ylabel('Probabilidade de erro (Pb)');
legend('Sinalização NRZ unipolar','Sinalização NRZ bipolar');
hold off;


% ------------- SEM FILTRO CASADO

figure,
subplot(311)
plot(info_tx1)
xlim([0 500])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação transmitida')

subplot(312)
plot(info_rx1)
xlim([0 500])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação recebida')

subplot(313)
plot(info_hat1)
xlim([0 50])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação recebida estimada')

figure,
subplot(311)
plot(info_tx2)
xlim([0 500])
ylim([-1.5 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação transmitida')

subplot(312)
plot(info_rx2)
xlim([0 500])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação recebida')

subplot(313)
plot(info_hat2)
xlim([0 50])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informação recebida estimada')