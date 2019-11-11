close all;
clear all;
clc;

N = 100;
M = 2;
fc = 5e3;
info = randint(1,10,M);

passo = ((2*length(info))/fc)/(length(info)*N);
info_format = rectpulse(info, N);
t = [0:passo:((2*length(info))/fc)-passo];

% Multiplica pelas portadoras de 5 e 10 kHz
s_t_FSK = (cos(2*pi*t*fc.*(info_format+1)));

plot(t, s_t_FSK')
title('Modulação FSK')

% Filtro passa faixa
info_f1_fpf;
info_f2_fpf;

% Módulo 
modulo_f1 = abs(info_f1_fpf);
modulo_f2 = abs(info_f2_fpf);

% Filtro passa baixa
info_f1_fpb;
info_f2_fpb;

% Decisão

