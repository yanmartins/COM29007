close all;
clear all;
clc;

% Pacote necessário para qammod
pkg load communications;

M = 16;  % Número de símbolos
k = 4;
N = 100; % Fator de superamostragem
fc = 10e3;

% Aqui já tenho os bits convertidos em símbolos
info = randi([0 M-1], 1, 100);

passo = ((2*length(info))/fc)/(length(info)*N);
t = [0:passo:((2*length(info))/fc)-passo];

% Realiza modulação QAM
info_qam = qammod(info, M);

% Separa a parte real e imaginária da modulação QAM
info_I = real(info_qam);    % In-phase
info_Q = imag(info_qam);    % Quadrature

% Formatando o sinal
info_I_format = rectpulse(info_I, N);
info_Q_format = rectpulse(info_Q, N);

psi_I = sin(2*pi*fc*t);
psi_Q = cos(2*pi*fc*t);

info_I_tx = info_I_format.*psi_I;
info_Q_tx = info_Q_format.*psi_Q;

% Junta a parte real e imaginária da modulação QAM (somatório)
info_tx = info_I_tx - info_Q_tx;

%******************************** PLOTS ***********************************
scatterplot(info_qam)
axis([-4 4 -4 4])

figure,
subplot(411)
    plot(t, info_I_format)
    xlim([0 5e-3])
    title('Informacao In-Phase')
subplot(412)
    plot(t, info_I_tx)
    xlim([0 5e-3])
    title('Informacao In-Phase Modulada')
subplot(413)
    plot(t, info_Q_format)
    xlim([0 5e-3])
    title('Informacao Quadrature')
subplot(414)
    plot(t, info_Q_tx)
    xlim([0 5e-3])
    title('Informacao Quadrature Modulada')

figure,
subplot(211)
    plot(t, rectpulse(info, N))
    xlim([0 5e-3])
    title('Informacao Original')
subplot(212)
    plot(t, info_tx)
    xlim([0 5e-3])
    title('Informaca a ser transmitida')