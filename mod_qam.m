close all;
clear all;
clc;

M = 16;  % Número de símbolos
k = 4;
N = 100; % Fator de superamostragem
fc = 10e3;

% Aqui já tenho os bits convertidos em símbolos
info = randi([0 M-1], 1, 100);
%info = [3 11 7];

passo = ((2*length(info))/fc)/(length(info)*N);
t = [0:passo:((2*length(info))/fc)-passo];

% Realiza modulação QAM
info_qam = qammod(info, M);
scatterplot(info_qam)

% Separa a parte real e imaginária da modulação QAM
info_I = real(info_qam);    % In-phase
info_Q = imag(info_qam);    % Quadrature

% Formatando o sinal
info_I_format = rectpulse(info_I, N);
info_Q_format = rectpulse(info_Q, N);

psi_I = cos(2*pi*fc*t);
psi_Q = sin(2*pi*fc*t);

% Informação a ser transmitida
info_I_tx = info_I_format.*psi_I;
info_Q_tx = info_Q_format.*psi_Q;
info_tx = info_I_tx - info_Q_tx;

figure,
subplot(411)
    plot(t, info_I_format)
    xlim([0 5e-3])
subplot(412)
    plot(t, info_I_tx)
    xlim([0 5e-3])
subplot(413)
    plot(t, info_Q_format)
    xlim([0 5e-3])
subplot(414)
    plot(t, info_Q_tx)
    xlim([0 5e-3])

figure,
subplot(211)
    plot(t, rectpulse(info, N))
    xlim([0 5e-3])
subplot(212)
    plot(t, info_tx)
    xlim([0 5e-3])



% filtro_tx = ones(1,k);
% 
% info_up_real = upsample(info_I, k); % Adiciona N-1 amostras entre cada amostras de info
% info_tx_real = filter(filtro_tx, 1, info_up_real); % O filtro define o formato do sinal
% 
% info_up_imag = upsample(info_Q, k); % Adiciona N-1 amostras entre cada amostras de info
% info_tx_imag = filter(filtro_tx, 1, info_up_imag); % O filtro define o formato do sinal

% Multiplica pelo psi 1

% Multiplica pelo psi 2

% Junta a parte real e imaginária da modulação QAM (somatório)