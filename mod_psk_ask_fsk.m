close all;
clear all;
clc;

t = [0:1/100e3:10e-3];

f1 = 1e3;
f2 = 2e3;

f = [f1 f2]';
A = [1 2]';

% Modulação PSK
s_psk1 = cos(2*pi*f1*t + 0);
s_psk2 = cos(2*pi*f1*t + pi/2);

% Modulação FSK
s_fsk = cos(2*pi*f*t);

% Modulação ASK
s_ask = A*cos(2*pi*f1*t);

figure,
subplot(311)
plot(t, s_psk1); hold on;
plot(t, s_psk2)
title('Modulação PSK')

subplot(312)
plot(t, s_fsk')
title('Modulação FSK')

subplot(313)
plot(t, s_ask)
title('Modulação ASK')
