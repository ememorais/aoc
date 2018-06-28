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
        0 => "0000000000000000", --nop
        1 => "1001100110000000", --ld %r2, 0
        2 => "1001101101111101", --ld %r6, 125
        3 => "0000000000000000", --nop
        4 => "0000000000000000", --nop
        5 => "0011101101000110", --add %r6, %r6
        6 => "1001101010000001", --ld %r5, 1
        7 => "0010100110011011", --ld.a %r3, %r3
        8 => "0000000000000000", --nop
        9 => "0000000000000000", --nop
        10 => "0011101001010110", --sub %r4, %r6
        11 => "0000000000000000", --nop
        12 => "0000000000000000", --nop
        13 => "0010011000010011", --ld[%r4], %r3
        14 => "0000000000000000", --nop
        15 => "0000000000000000", --nop
        16 => "0011010111000110", --cmp.a $r3, $r6
        17 => "0000000000000000", --nop
        18 => "0000000000000000", --nop
        19 => "0000100000010000", --jplt -5
        others => (others => '0')
    );

    signal data_out_s : unsigned(15 downto 0) := "0000000000000000";
    
begin

    data_out_s <= content(to_integer(addr));

    data_out <= data_out_s;

end a_s1c17_rom;