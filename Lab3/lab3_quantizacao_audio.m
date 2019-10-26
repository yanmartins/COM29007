## Capturar um sinal de áudio utilizando as ferramentas do
## toolbox 'Data Acquisition'. Utilizar o matlab no windows.
## • Realizar um processo de quantização uniforme do sinal (3, 5, 8 e 13 bits)
## • Diponibilizar o sinal na placa de som do micro e observar os efeitos da quantização

close all;
clear all;
clc;

A = 1;                % Amplitude
Vpp = 2*A;            % Tensão pico a pico
k_vec = [8 13];   % Número de bits do quantizador

[x_n,Fs_in] = audioread('som_mod_AM.wav');
x_n = x_n(:,1);

end_t = (length(x_n)/Fs_in-(1/Fs_in));
t = [0:1/Fs_in:end_t];
f = [-Fs_in/2:1/end_t:Fs_in/2];

% Realiza a transformada de Fourier e desloca o componente de frequência zero 
% para o centro do espectro.
x_n_fft = fftshift(fft(x_n)/length(x_n));

% Cria um filtro passa-baixa.
filtro_PB = fir1(10, (1500*2)/Fs_in);

audio = audioplayer(x_n, Fs_in);
play(audio)

figure,
subplot(121)
plot(t, x_n)
title('Áudio original no domínio do tempo')
xlabel('Tempo [s]')
ylabel('Amplitude [V]')

subplot(122)
plot(f, abs(x_n_fft))
title('Áudio original no domínio da frequência')
xlabel('Frequência [Hz]')
ylabel('Amplitude [V]')
pause(4)

% Realiza processos de quantização com diferentes quantidades de bits
for k = k_vec
    L = 2^k;
    passo_q = Vpp/L; % Passo de quantização
    
    x_quant = (x_n + A)-(passo_q/2);
    x_quant = x_quant/passo_q;
    x_quant = round(x_quant);

    % Ajustando a quantização
    aux1 = x_quant == L;      % Gera um vetor bolleano para 2^k
    aux2 = x_quant == -1;     % Gera um vetor bolleano para -1
    x_quant = x_quant - aux1; % Ajusta máximo até 2^k-1
    x_quant = x_quant + aux2; % Ajusta mínimo em 0

    x_bin = de2bi(x_quant);
    [linha, coluna] = size(x_bin);
    x_bin = reshape(transpose(x_bin), 1, linha*coluna);

    x_serial = reshape(x_bin, coluna, linha);
    x_serial = transpose(x_serial);
    x_serial = transpose(bi2de(x_serial));
    
    x_n_rec = x_serial * passo_q;
    x_n_rec = x_n_rec - ((Vpp/2)-(passo_q/2));
    x_n_rec_fft = fftshift(fft(x_n_rec)/length(x_n_rec));
    
    y_n = filter(filtro_PB, 1, x_n_rec);
    y_fft = fftshift(fft(y_n)/length(y_n));
    
    figure,
    % Áudio Recuperado
    subplot(221)
    plot(t, x_n_rec)
    title(['Áudio no domínio do tempo. Quantização de ', num2str(k), ' bits'])
    xlabel('Tempo [s]')
    ylabel('Amplitude [V]')
    subplot(222)
    plot(f, abs(x_n_rec_fft))
    title(['Áudio no domínio da frequência. Quantização de ', num2str(k), ' bits'])
    xlabel('Frequência [Hz]')
    ylabel('Amplitude [V]')
    
    % Reproduzindo áudio recuperado
    audio_rec = audioplayer(x_n_rec', Fs_in);
    play(audio_rec)
    pause(4) 
    
    % Áudio Recuperado e Filtrado
    subplot(223)
    plot(t, y_n)
    title('Áudio filtrado no domínito do tempo')
    xlabel('Tempo [s]')
    ylabel('Amplitude [V]')
    subplot(224)
    plot(f, abs(y_fft))
    title('Áudio filtrado no domínito da frequência')
    xlabel('Frequência [Hz]')
    ylabel('Amplitude [V]')
    
    % Reproduzindo áudio recuperado e filtrado
    audio_rec_f = audioplayer(y_n', Fs_in);
    play(audio_rec_f)
    pause(4)
end