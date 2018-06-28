--************************************************************
-- S1C17 READ ONLY MEMORY
-- EQUIPE 6 - MARCELO E JOAO
-- TODO: ROM de 256 bytes contendo código de teste utilizado para
-- visualização do funcionamento da ISA S1C17. A ROM é excepcionalmente
-- endereçada de 2 em 2 bytes para maior facilidade de visualização e de testes.
--************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity s1c17_rom is
    port(
        clk      : in  std_logic;
        addr     : in  unsigned(23 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity s1c17_rom;

architecture a_s1c17_rom of s1c17_rom is

    type memory is array(0 to 127) of unsigned(15 downto 0);
    constant content : memory := (
        --INICIALIZACAO
        0 => "0000000000000000", --nop
        1 => "1001100110000000", --ld %r3, 0
        2 => "1001101110110010", --ld %r7, 50
        3 => "1001101100110010", --ld %r6, 50
        4 => "0000000000000000", --nop
        5 => "0000000000000000", --nop
        6 => "0011101101000110", --add %r6, %r6
        7 => "0000000000000000", --nop
        8 => "0000000000000000", --nop
        9 => "0011101101000110", --add %r6, %r6
        10 => "0000000000000000", --nop
        11 => "0000000000000000", --nop
        12 => "0011101101000111", --add %r6, %r7
        13 => "0000000000000000", --nop
        14 => "0000000000000000", --nop
        --OK
        15 => "1001101010000001", --ld %r5, 1
        16 => "0000000000000000", --nop
        17 => "0000000000000000", --nop
        18 => "0011100111000101", --ld.a %r3, %r5
        19 => "0000000000000000", --nop
        20 => "0000000000000000", --nop
        21 => "0010101000011110", --ld.a %r4, %r6
        22 => "0000000000000000", --nop
        23 => "0000000000000000", --nop
        24 => "0011101001010011", --sub %r4, %r3
        25 => "0000000000000000", --nop
        26 => "0000000000000000", --nop
        27 => "0010011000010011", --ld [%r3], %r4
        28 => "0000000000000000", --nop
        29 => "0000000000000000", --nop
        30 => "0011010111000110", --cmp.a $r3, $r6
        31 => "0000000000000000", --nop
        32 => "0000000000000000", --nop
        33 => "0000100001101100",  --jplt -5
        34 => "0000000000000000", --nop
        35 => "0000000000000000", --nop
        others => (others => '0')
    );

    signal data_out_s : unsigned(15 downto 0) := "0000000000000000";
    
begin

    data_out_s <= content(to_integer(addr));

    data_out <= data_out_s;

end a_s1c17_rom;