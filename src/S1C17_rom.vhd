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
        0  => "0000000000000000", --nop
        1  => "1001100110000000", --ld %r3, 0x00
        2  => "1001101000000000", --ld %r4, 0x00
        3  => "1001101010000001", --ld %r5, 0x01
        4  => "1001101100011110", --ld %r6, 0x30
        5  => "0011101001000011", --add %r4, %r3
        6  => "0011100111000101", --add %r3, %r5 (r3 + 1)
        7  => "0000000000000000", --nop
        8  => "0000000000000000", --nop
        9  => "0011010111000110", --cmp %r3, %r6 (r3, 30)
        10 => "0000000000000000", --nop
        11 => "0000000000000000", --nop
        12 => "0000100001110111", --jplt -9
        13 => "0000000000000000", --nop
        14 => "0000000000000000", --nop
        15 => "0010101010011100", --ld %r5, r4
        others => (others => '0')
    );

    signal data_out_s : unsigned(15 downto 0) := "0000000000000000";
    
begin

    -- process(clk)
    -- begin
    --     if(rising_edge(clk)) then
            data_out_s <= content(to_integer(addr));
    --     end if;
    -- end process;

    data_out <= data_out_s;

end a_s1c17_rom;