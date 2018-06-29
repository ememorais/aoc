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
        1 =>  "1001101010000001",
        2 =>  "1001100010100001",
        3 =>  "0010010100010010",
        4 =>  "0011100101000101",
        5 =>  "0011010101000001",
        6 =>  "1001101100001110",
        8 =>  "0000100001110110",
        11 => "1001100000000010",
        12 => "1001100100000000",
        15 => "0010001000010010",
        18 => "0011011001000111",
        21 => "0000100000000011",
        24 => "0011101001010000",
        27 => "0000000101001110",
        others => (others => '0')
    );

    signal data_out_s : unsigned(15 downto 0) := "0000000000000000";
    
begin

    data_out_s <= content(to_integer(resize(addr,7)));

    data_out <= data_out_s;

end a_s1c17_rom;