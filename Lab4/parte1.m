% Simular uma transmiss�o bin�ria com os seguintes par�metros:
% � Sequ�ncia de informa��o [0 1 1 0 1 0 1 1 0 1 0];
% � Sinaliza��o NRZ unipolar com n�vel de amplitude de 1V;
% � Canal AWGN com SNR = 10 dB;
% � Recep��o com e sem filtro casado (implementar as duas solu��es)
% � Apresentar os gr�ficos de todos os est�gios da transmiss�o, comentar e concluir os resultados;

pkg load communications; % Pacote para rodar no Octave

close all;
clear all;
clc;

N = 10;             % Fator de superamostragem, n�mero de amostras por simbolo
M = 2;              % N�mero de n�ves de transmiss�o
l = log2(M);        % Quantidade de bits por n�vel de transmiss�o

t_final = 11;       % Tempo em segundos
Rb = 1;             % Taxa de transmiss�o
Rs = Rb/l;          % Taxa de transmiss�o de s�mbolos

fa = Rb*N;          % Frequ�ncia de amostragem
t = [0:(1/fa):t_final-(1/fa)];

% Sinaliza��o 1
A = 1;            
limiar = A/2;
dist_nivel = A;   % Dist�ncia entre n�veis

num_simb = Rs*t_final;

SNR = 10;

filtro_tx = ones(1,N);
filtro_rx = fliplr(filtro_tx); % Filtro casado na recep��o

info_bin = [0 1 1 0 1 0 1 1 0 1 0];  % Informa��o bin�ria que ser� transmitida
info_bin = reshape(info_bin, l, num_simb)';

info = bi2de(info_bin, 'left-msb')*dist_nivel;

info_up = upsample(info, N); % Adiciona N-1 amostras entre cada amostras de info

% Transmiss�o
info_tx = filter(filtro_tx, 1, info_up); % O filtro define o formato do sinal

% Recep��o
info_rx = awgn(info_tx, SNR, 10*log10(A)); % Gera o ru�do branco em fun��o da vari�ncia SNR

% Sem filtro casado
info_hat_whithout_filter = info_rx(N : N : end) > limiar; % Infomar��o estimada

% Com filtro casado
info_rx_filter = filter(filtro_rx, 1, info_rx)/N;
info_hat = info_rx_filter(N : N : end) > limiar; % Infomar��o estimada

% ------------- SEM FILTRO CASADO

figure,
subplot(411)
stem(info_bin);
xlim([1 12])
xlabel('Tempo [s]');
ylabel('Bits');
title('Informa��o bin�ria')

subplot(412)
plot(t, info_tx)
xlim([0 11])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o transmitida')

subplot(413)
plot(t, info_rx)
xlim([0 11])
ylim([-1 2])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o recebida')

subplot(414)
stem(info_hat_whithout_filter)
xlim([1 12])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o recebida estimada')

% ------------- COM FILTRO CASADO

figure,
subplot(511)
stem(info_bin);
xlim([1 12])
xlabel('Tempo [s]');
ylabel('Bits');
title('Informa��o bin�ria')

subplot(512)
plot(t, info_tx)
xlim([0 11])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o transmitida')

subplot(513)
plot(t, info_rx)
xlim([0 11])
ylim([-1 2])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o recebida')

subplot(514)
plot(t, info_rx_filter)
xlim([0 11])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o recebida filtrada')

subplot(515)
plot(info_hat)
xlim([0 11])
ylim([0 1.5])
xlabel('Tempo [s]');
ylabel('Amplitude [V]');
title('Informa��o recebida filtrada e estimada')