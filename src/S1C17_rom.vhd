--************************************************************
-- S1C17 READ ONLY MEMORY
-- EQUIPE 6 - MARCELO E JOAO
-- TODO: Completar
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
        0  =>  "0000000000000000", 
        1  =>  "1001100100110000",  --ld   %r2, 0x30
        2  =>  "1001101110000111",  --ld   %r7, 0x07
        3  =>  "0011100101000111",  --add  %r2, %r7
        4  =>  "1001100000000010",  --ld   %r0, 0x02
        5  =>  "0011100101010000",  --sub  %r2, %r0
        6  =>  "1001100110000001",  --ld   %r3, 0x01
        7  =>  "0010101100011010",  --ld.a %r6, %r2
        8  =>  "0011010101000011",  --cmp.a %r2, %r3
        9  =>  "0000000101001011",  --jpa  %r3
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