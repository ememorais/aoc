ld r5 1  //carrega os 33 numeros R5 ITERADOR NAO MEXE
ld r1 33 //r2 iterador
ld r6 14
ld [r2], r2
add r2, r5
cmp r2, r1 //verificar ordem


jrlt -3


ld r0 2
ld r2 0 //r2 iterador


ld r4 [r2] //r4 valor lido ram


cmp r4 r7 //R4 <= 0


jplt +3


sub r4, r0 //r4 - r0


jpa 14


cmp r4, r7


jrne 6


ld [r2], r7


add r2, r5

cmp r2, r1

jrlt 29















ld r1 3
ld r2 5
ld [r3] r0
add r3, r5


ld [r3], r1
add r3, r5


ld [r3] r2

        11 => "1001100010000011"
        11 => "1001100100000101"
        11 => "0010010000010011"