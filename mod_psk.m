clear all;
close all;
clc;

M = 4;

info = randint(1, 10, M)
info_mod = exp(1j*2*pi*info/M);

info_demod = real(info_mod) < 0

% Gráfico de dispersão
% scatterplot(info_mod)

% figure,
% subplot(311)
% plot(info)
% title('Informação')
% ylim([0 1.5])
% 
% subplot(312)
% plot(info_mod)
% title('Modulação PSK')
% 
% subplot(313)
% plot(info_demod)
% title('Modulação ASK')