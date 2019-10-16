close all;
%clear all;
clc;

N = 100;            % Fator de superamostragem, número de amostras por simbolo
M = 2;              % Número de níves de transmissão (potência de base dois)
fc = 10e3;          % Frequência da portadora
t_final = 1;        % Tempo em segundos (números inteiros)
Rb = 2e3;           % Taxa de transmissão
l = log2(M);        % Quantidade de bits por nível de transmissão
Rs = Rb/l;          % Taxa de transmissão de símbolos

fa = Rb*N;          % Frequência de amostragem
t = [0:(1/fa):t_final-(1/fa)];
f = [-(Rs*N)/2:1/(t_final):(Rs*N)/2-(1/(t_final))];

A = sqrt(M);        % Amplitude máxima
limiar = 0;
dist_nivel = A*2;   % Distância entre níveis

num_simb = Rs*t_final;

SNR = 10;

filtro_tx = ones(1,N);
filtro_rx = fliplr(filtro_tx);
c_t = cos(2*pi*fc.*t);    % Portadora
info_bin = randi([0 1], 1, num_simb*l);
info_bin = reshape(info_bin, l, num_simb)';

info = bi2de(info_bin, 'left-msb')*dist_nivel- A;

info_up = upsample(info, N); % Adiciona N-1 amostras entre cada amostras de info
info_tx = filter(filtro_tx, 1, info_up); % O filtro define o formato do sinal

info_rx = awgn(info_tx, SNR-(log10(N))); % Gera o ruído branco em função da variância SNR
info_rx_filter = filter(filtro_rx, 1, info_rx)/N;
info_hat = info_rx_filter(N : N : end) > limiar; % Infomarção estimada

num_erros = sum(xor(info_bin, info_hat));
taxa_erro = num_erros/length(info_bin);

% ************************ Sinal Tx *************************
figure,
subplot(421)
plot(t, info_tx)
axis([0 10/Rs -1.1*A 1.1*A])
grid on

subplot(422)
info_TX = fftshift(fft(info_tx));
plot(f, abs(info_TX))
xlim([-5*Rs 5*Rs])

% ************************ Sinal Rx *************************
subplot(423)
plot(t, info_rx)
xlim([0 10/Rs])
grid on

subplot(424)
info_RX = fftshift(fft(info_rx));
plot(f, abs(info_RX))
xlim([-5*Rs 5*Rs])

% ************** Transmissão em banda passante ***************
info_tx_rf = info_tx.*c_t';
info_rx_rf = info_tx_rf.*c_t';

subplot(425)
plot(t, info_tx_rf)
axis([0 10/Rs -1.1*A 1.1*A])
grid on

subplot(426)
info_TX_RF = fftshift(fft(info_tx_rf));
plot(f, abs(info_TX_RF))

subplot(427)
plot(t, info_rx_rf)
axis([0 10/Rs -1.1*A 1.1*A])
grid on

subplot(428)
info_RX_RF = fftshift(fft(info_rx_rf));
plot(f, abs(info_RX_RF))
