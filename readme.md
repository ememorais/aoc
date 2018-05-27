# Laboratório AOC - ISA S1C17 em VHDL

## Considerações da ISA implementadas:

* O Program Counter possui 24 bits embora guarde endereços de 16 bits. O 1º bit
do PC é sempre 0. Os dados de endereço são os bits 16-1.

* A arquitetura não possui um número fixo de bits para decoding da instrução.

* O pipeline implementado não possui precauções contra hazards; por isso, todas
as instruções que precisarem de dados de instruções sendo executadas 
imediatamente antes devem ser preenchidas com nops para que o dado possa se
propagar corretamente.

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