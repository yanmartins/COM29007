close all;
clear all;
clc;

N = 100;
M = 2;
fc = 10e3;
info = randint(1,10,M);

passo = ((2*length(info))/fc)/(length(info)*N);
info_format = rectpulse(info, N);
t = [0:passo:((2*length(info))/fc)-passo];

s_t_PSK = ((info_format*2)-1).*cos(2*pi*t*fc);
s_t_ASK = (info_format).*cos(2*pi*t*fc);
s_t_FSK = (cos(2*pi*t*fc.*(info_format+1)));

figure,
subplot(411)
plot(info_format)
title('Informação')
ylim([0 1.5])

subplot(412)
plot(t, s_t_PSK)
title('Modulação PSK')

subplot(413)
plot(t, s_t_ASK)
title('Modulação ASK')

subplot(414)
plot(t, s_t_FSK')
title('Modulação FSK')
