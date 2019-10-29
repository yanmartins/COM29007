close all;
clear all;
clc;

M = 16; % número de símbolos

% Aqui já tenho os bits convertidos em símbolos
%info = randi([0 M-1], 1, 10);
info = [3 10 8];

% Realiza modulação QAM
info_qam = qammod(info, M);

% Separa a parte real e imaginária da modulação QAM
info_real = real(info_qam);
info_imag = imag(info_qam);

% Realiza modulação PAM
info_pam_real = pammod(abs(info_real), 4);
info_pam_imag = pammod(abs(info_imag), 4);

% Multiplica pelo psi 1

% Multiplica pelo psi 2

% Junta a parte real e imaginária da modulação QAM (somatório)