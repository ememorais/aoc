--Coleção de ROMs que podem ser utilizadas em s1c17_rom.vhd

--ROM Principal
        0  =>  "0000000000000000",  --nop
        1  =>  "1001100100110000",  --ld   %r2, 0x30
        2  =>  "1001101110000111",  --ld   %r7, 0x07
        3  =>  "0000000000000000",  --nop
        4  =>  "0000000000000000",  --nop
        5  =>  "0011100101000111",  --add  %r2, %r7
        6  =>  "1001100000000010",  --ld   %r0, 0x02
        7  =>  "0000000000000000",  --nop
        8  =>  "0011100101010000",  --sub  %r2, %r0
        9 =>  "1001100110000001",   --ld   %r3, 0x01
        10 =>  "0010101100011010",  --ld.a %r6, %r2
        11 =>  "0000000000000000",  --nop
        12 =>  "0000000000000000",  --nop
        13 =>  "0011010101000011",  --cmp.a %r2, %r3
        14 =>  "0000000101001011",  --jpa  %r3

--ROM de teste de ld.a
        0  =>  "0000000000000000",  --nop
        1  =>  "1001100100110000",  --ld   %r2, 0x30
        2  =>  "0000000000000000",  --nop
        3  =>  "0000000000000000",  --nop
        4 =>  "0010101100011010",   --ld.a %r6, %r2

