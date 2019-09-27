close all;
clear all;
clc;

A = 1;
T = 10;

Eb_No_dB = 0:15;
Eb_No = db2pow(Eb_No_dB);

Pb_unipolar = qfunc(sqrt(Eb_No));
Pb_bipolar = qfunc(sqrt(2*Eb_No));

figure,
semilogy(Eb_No_dB, Pb_unipolar);hold on; grid on;
semilogy(Eb_No_dB, Pb_bipolar);
legend('Sinalização Unipolar', 'Sinalização Bipolar')
title('Probabilidade de erro para sinalização binária')
xlabel('Eb/No [dB]')
ylabel('Pb')
ylim([1e-7 1])
