close all;
clear all;
clc;

N = 10;             % Fator de superamostragem, n�mero de amostras por simbolo
M = 2;              % N�mero de n�ves de transmiss�o
l = log2(M);        % Quantidade de bits por n�vel de transmiss�o

t_final = 11;       % tempo em segundos
Rb = 100000;         % taxa de transmiss�o
Rs = Rb/l;          % taxa de transmiss�o de s�mbolos
fa = Rb*N;          % Frequ�ncia de amostragem

A1 = 1;

limiar1 = A1/2;

num_simb = Rs*t_final;

SNR_max = 25;

filtro_tx = ones(1,N);
filtro_rx = fliplr(filtro_tx); % Filtro casado na recep��o

info = randint(1, Rb);  % Informa��o bin�ria que ser� transmitida

info_nrz1 = info * A1;

info_up1 = upsample(info_nrz1, N); % Adiciona N-1 amostras entre cada amostras de info

% Transmiss�o
info_tx1 = filter(filtro_tx, 1, info_up1); % O filtro define o formato do sinal

% Verifica��o de erro em fun��o da SNR
for SNR = 0 : SNR_max
    % Recep��o
    info_rx1 = awgn(info_tx1, SNR, 10*log10(A1)); % Gera o ru�do branco em fun��o da vari�ncia SNR
    
    % Sem filtro casado
    info_hat_whithout_filter1 = info_rx1(N : N : end) > limiar1; % Informa��o estimada
    
    % Com filtro casado
    info_rx_filter = filter(filtro_rx, 1, info_rx1)/N;
    info_hat = info_rx_filter(N : N : end) > limiar1; % Informa��o estimada
    
    % Probabilidade de erro de bit do sinal Rx
    Pb1(SNR+1) = sum(xor(info_nrz1,info_hat_whithout_filter1))/length(info_hat_whithout_filter1);
    Pb2(SNR+1) = sum(xor(info_nrz1,info_hat))/length(info_hat);
end

% Plotando os resultados
figure, 
semilogy([0:SNR_max],Pb1); hold on;
semilogy([0:SNR_max],Pb2);
xlabel('SNR');
ylabel('Probabilidade de erro (Pb)');
legend('Sinaliza��o NRZ unipolar SEM filtro casado','Sinaliza��o NRZ unipolar COM filtro casado');
hold off;


% ------------- SEM FILTRO CASADO

figure,
subplot(311)
plot(info_tx1)
xlim([0 500])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o transmitida')

subplot(312)
plot(info_rx1)
xlim([0 500])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o recebida')

subplot(313)
plot(info_hat_whithout_filter1)
xlim([0 50])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o recebida estimada')

figure,
subplot(311)
plot(info_tx1)
xlim([0 500])
ylim([0 2.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o transmitida')

subplot(312)
plot(info_rx1)
xlim([0 500])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o recebida')

subplot(313)
plot(info_hat)
xlim([0 50])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o recebida estimada')