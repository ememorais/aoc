# Laboratório AOC - ISA S1C17 em VHDL


- [Laboratório AOC - ISA S1C17 em VHDL](#laboratorio-aoc---isa-s1c17-em-vhdl)
  - [Considerações da ISA implementadas:](#consideraces-da-isa-implementadas)
  - [Instruções Implementadas](#instruces-implementadas)
    - [1. add %rd, %rs](#1-add-rd--rs)
    - [2. sub %rd, %rs](#2-sub-rd--rs)
    - [3. ld %rd, sign7](#3-ld-rd--sign7)
    - [4. ld.a %rd, %rs](#4-lda-rd--rs)
    - [5. jpa %rb](#5-jpa-rb)
    - [6. nop](#6-nop)
    - [7. cmp.a](#7-cmpa)
  - [Código Executado](#codigo-executado)
  - [Exemplo de Execução (GTKWave)](#exemplo-de-execucao-gtkwave)


## Considerações da ISA implementadas:

* Várias partes da ISA lidam com tamanhos diferentes de barramento:
  
  * Instruções: 16 bits
  * Registradores: 24 bits
  * Memória de dados: 32 bits (não implementada aqui)

* A arquitetura é do tipo RISC, com as instruções principais de tamanho fixo e
* executadas em um ciclo (considerando pipeline)

* A arquitetura não possui um número fixo de bits para decoding da instrução.

* O pipeline implementado neste modelo não possui precauções contra _hazards_; 
por isso, todas as instruções que precisarem de dados de instruções sendo executadas imediatamente antes devem ser preenchidas com nops para que o dado 
possa se propagar corretamente.



## Instruções Implementadas

### 1. add %rd, %rs

```
15                                      0
[ 0 0 1 1 1 0 | D D D | 1 0 0 0 | S S S ]  
  OPCODE        RD                RS

[ IL IE C V Z N ] (X : modifica flag)
  –  –  X X X X
```

### 2. sub %rd, %rs

```
15                                      0
[ 0 0 1 1 1 0 | D D D | 1 0 1 0 | S S S ]  
  OPCODE        RD                RS

[ IL IE C V Z N ] (X : modifica flag)
  –  –  X – X X
```

### 3. ld %rd, sign7
O valor imediato de 7 bits sign7 é carregado no registrador rd após ter seu
sinal extendido para 16 bits.
```
15                                      0
[ 1 0 0 1 1 0 | D D D | S S S S   S S S ]  
  OPCODE        RD      SIGN7

[ IL IE C V Z N ] (X : modifica flag)
  –  –  – – – –
```

### 4. ld.a %rd, %rs
O conteúdo do registrador rs é transferido para o registrador rd.
```
15                                      0
[ 0 0 1 0 1 0 | D D D | 0 0 1 1 | S S S ]  
  OPCODE        RD                RS

[ IL IE C V Z N ] (X : modifica flag)
  –  –  – – – –
```

### 5. jpa %rb
O conteúdo do registrador rb é colocado no PC e o programa pula para este
endereço. O LSB do registrador é ignorado e considerado como 0.
```
15                                      0
[ 0 0 0 0 0 0 | 0 1 0   1 0 0 1 | B B B ]  
  OPCODE                          RB

[ IL IE C V Z N ] (X : modifica flag)
  –  –  – – – –
```

### 6. nop
Nenhuma operação é feita exceto incremento do PC.
```
15                                      0
[ 0 0 0 0 0 0   0 0 0   0 0 0 0   0 0 0 ]  
  OPCODE                          

[ IL IE C V Z N ] (X : modifica flag)
  –  –  – – – –
```

### 7. cmp.a
Subtrai o conteúdo do registrador rs do registrador rd, e seta/limpa as flags C e Z de acordo com os resultados. Não muda o conteúdo de rd em sua execução.
```
15                                      0
[ 0 0 1 1 0 1 | D D D | 1 0 0 0 | S S S ]  
  OPCODE        RD                RS  

[ IL IE C V Z N ] (X : modifica flag)
  –  –  X X X X
  
```

### 7. jplt
Pula para o endereço relativo em SIGN7 se 
a flag de carry for 1 (ou seja, a comparação
detectou que rd < rs)

```
15                                      0
[ 0 0 0 0 1 0   0 0 0 | S S S S   S S S ]  
  OPCODE                SIGN7

[ IL IE C V Z N ] (X : modifica flag)
  –  –  - - - -
```

## Código Executado

Na ROM atual, o seguinte código é executado:
```
nop
ld   %r2, 0x30
ld   %r7, 0x07
nop
nop
add  %r2, %r7
ld   %r0, 0x02
nop
sub  %r2, %r0
ld   %r3, 0x08
ld.a %r6, %r2
nop
nop
cmp.a %r7, %r3
cmp.a %r4, %r5
jpa  %r3

```

* _0x30_ e _0x07_ são armazenados em R2 e R7 e somados;
* _0x02_ é armazenado em R0 e subtraído da soma anterior (em R2);
* _0x08_ é armazenado em R3;
* O valor em R2 (atualmente _0x35_) é copiado par R6;
* R7 e R3 são comparados (R7 < R3, flag CARRY é ativada);
* R4 e R5 são comparados (R4 == R5, flag ZERO é ativada);
* Pulo para *R3 (0x08) -- Loop acontece subsequentemente. 

## Exemplo de Execução (GTKWave)

![](https://i.imgur.com/UKWqRBg.png)
