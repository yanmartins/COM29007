close all;
clear all;
clc;

L = 10;
N = 100;
M = 2;
fc = 10e3;
info = randi([0 M-1], [1 L]);
passo = (2*length(info)/fc)/(length(info)*N);
info_format = rectpulse(info, N);
t = [0:passo:(2*length(info)/fc)-passo];
fa = 1/passo;

% Multiplica pelas portadoras de 5 e 10 kHz
s_t_fsk = cos(2*pi*fc*t.*(info_format+1));

% Filtro passa faixa
fpf_10k = fir1(100, ([5e3 15e3]*2)/fa);
fpf_20k = fir1(100, ([15e3 25e3]*2)/fa);
info_10k = filter(fpf_10k, 1, s_t_fsk);
info_20k = filter(fpf_20k, 1, s_t_fsk);

% Módulo 
info_10k_abs = abs(info_10k);
info_20k_abs = abs(info_20k);

% Filtro passa baixa
fpb_10k = fir1(100, (5e3*2)/fa);
fpb_20k = fir1(100, (10e3*2)/fa);
info_out_10k = filter(fpb_10k, 1, info_10k_abs);
info_out_20k = filter(fpb_20k, 1, info_20k_abs);

% Decisão
limiar = 0.5;
info_hat_10k = (info_out_10k > limiar);
info_hat_20k = (info_out_20k > limiar);

%******************************** PLOTS ***********************************
figure,
subplot(211)
    plot(t, info_format)
    title('Sinal de Informacao');
    xlabel('tempo [s]'); ylabel('Amplitude [V]');
    ylim([-0.5 1.5])
subplot(212)
    plot(t, s_t_fsk)
    title('Sinal Modulado');
    xlabel('tempo [s]'); ylabel('Amplitude [V]');
    ylim([-1.5 1.5])
    
figure,
subplot(211)
    plot(t, info_10k)
    title('Sinal Frequencia 10 KHz');
    xlabel('tempo [s]'); ylabel('Amplitude [V]');
    ylim([-1 1])
subplot(212)
    plot(t, info_20k)
    title('Sinal Frequencia 20 KHz');
    xlabel('tempo [s]'); ylabel('Amplitude [V]');
    ylim([-1 1])
    
figure,
subplot(221)
    plot(t, info_10k_abs)
    title('Sinal Absoluto (10 KHz)');
    xlabel('tempo [s]'); ylabel('Amplitude [V]');
    ylim([0 1])
subplot(222)
    plot(t, info_20k_abs)
    title('Sinal Absoluto (20 KHz)');
    xlabel('tempo [s]'); ylabel('Amplitude [V]');
    ylim([0 1])
subplot(223)
    plot(t, info_out_10k)
    title('Sinal Envoltoria (10 KHz)');
    xlabel('tempo [s]'); ylabel('Amplitude [V]');
subplot(224)
    plot(t, info_out_20k)
    title('Sinal Envoltoria (20 KHz)');
    xlabel('tempo [s]'); ylabel('Amplitude [V]');
    
figure,
subplot(211)
    plot(t, info_hat_10k)
    title('Informacao reconstruida 10 KHz');
    xlabel('tempo [s]'); ylabel('Amplitude [V]');
    ylim([-0.5 1.5])
subplot(212)
    plot(t, info_hat_20k)
    title('Informacao reconstruida 20 KHz');
    xlabel('tempo [s]'); ylabel('Amplitude [V]');
    ylim([-0.5 1.5])