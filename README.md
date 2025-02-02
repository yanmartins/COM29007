﻿**Instituto Federal de Santa Catarina**

# Sistemas de Comunicação I

Repositório para uso na disciplina de Sistemas de Comunicação I (COM29007) do curso de Engenharia de Telecomunicações do Instituto Federal de Santa Catarina - câmpus São José, realizada em 2019.2

Para o Octave, é necessário instalar alguns pacotes:

```
apt-get install octave-signal
apt-get install octave-communications
```

O pacote `communications` não possui a função `rectpulse` implementada. Portanto, para alguns códigos, foi utilizada a implementação de [Horacio Sanson](https://github.com/hsanson/scde/blob/master/src/rectpulse.m):

- [rectpulse.m](https://github.com/yanmartins/COM29007/blob/master/rectpulse.m)

# Laboratórios

 - [Lab 3 - Quantização e codificação de sinal de áudio](https://github.com/yanmartins/COM29007/tree/master/Lab3)
 - [Lab 4 - Transmissão binária e análise de desempenho de erro](https://github.com/yanmartins/COM29007/tree/master/Lab4)
 - [Lab 5 - Modulação 16-QAM e BFSK com detecção de envoltória](https://github.com/yanmartins/COM29007/tree/master/Lab5)
 
# Aulas

## SETEMBRO

### 13/set/2019

PCM, sinalização binária e multinível. Superamostragem, formatação do sinal, amostragem e quantização.

- [formatacao_do_sinal.m](https://github.com/yanmartins/COM29007/blob/master/formatacao_do_sinal.m)

### 16/set/2019

PCM, sinalização binária e multinível. Detecção de sinais binários em um canal AWGN.

- [recepcao_com_ruido.m](https://github.com/yanmartins/COM29007/blob/master/recepcao_com_ruido.m)

### 18/set/2019

Desempenho sinal x ruído. Limitando potência do ruído através de um filtro passa baixa na recepção.

- [tratando_sinal_recv.m](https://github.com/yanmartins/COM29007/blob/master/tratando_sinal_recv.m)

### 20/set/2019

Comparação do desempenho de erros de duas sinalizações.

- [desempenho_2_sinalizacoes.m](https://github.com/yanmartins/COM29007/blob/master/desempenho_2_sinalizacoes.m)


### 25/set/2019

Correlação e filtro casado.

- [filtro_casado.m](https://github.com/yanmartins/COM29007/blob/master/filtro_casado.m)

### 27/set/2019

Probabilidade de erro para sinalização binária, teórica.

- [prob_erro_sinali_binaria.m](https://github.com/yanmartins/COM29007/blob/master/prob_erro_sinali_binaria.m)

## OUTUBRO

### 16/out/2019

- [tx_rx_NRZ.m](https://github.com/yanmartins/COM29007/blob/master/tx_rx_NRZ.m)

### 23/out/2019 - 25/out/2019

Tipos de modulações digitais: PSK, ASK e FSK.

- [mod_psk_ask_fsk.m](https://github.com/yanmartins/COM29007/blob/master/mod_psk_ask_fsk.m)
- [mod_psk.m](https://github.com/yanmartins/COM29007/blob/master/mod_psk.m)

### 29/out/2019

Processos de uma modulação QAM.

- [mod_qam.m](https://github.com/yanmartins/COM29007/blob/master/mod_qam.m)

## NOVEMBRO

### 06/out/2019

Continuação da modulação QAM.

- [mod_qam.m](https://github.com/yanmartins/COM29007/blob/master/mod_qam.m)

### 11/nov/2019

Modulação BFSK com detecção não coerente.

- [mod_bfsk.m](https://github.com/yanmartins/COM29007/blob/master/mod_bfsk.m)
