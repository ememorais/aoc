--************************************************************
-- S1C17 CONTROL UNIT
-- EQUIPE 6 - MARCELO E JOAO
-- Unidade de controle que realiza decodificação de instruções recebidas e 
-- a determinação de sinais de controle específicos para a instrução recebida.
--************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity s1c17_control_unit is
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        c, z        : in std_logic;
        instr_in    : in unsigned(15 downto 0);
        WEFile      : out std_logic;
        WDSrc       : out unsigned(1 downto 0);
        PCSrc       : out std_logic;
        ALUOp       : out unsigned(1 downto 0);
        PCImm       : out std_logic;
        FLUpdt      : out std_logic
        );
end s1c17_control_unit;

architecture a_s1c17_control_unit of s1c17_control_unit is

    signal  decoded_add,
            decoded_sub,
            decoded_ld,
            decoded_ld_imm7,
            decoded_jpa,
            decoded_nop,
            decoded_cmp,
            decoded_jrlt      : std_logic;

begin

    ------------Decodificação de Instruções------------

    decoded_add <=      '1' when    instr_in(15 downto 10) = "001110"
                                    and
                                    instr_in(6 downto 3)   = "1000"
                            else
                        '0';

    decoded_sub <=      '1' when    instr_in(15 downto 10) = "001110"
                                    and
                                    instr_in(6 downto 3)   = "1010"
                            else
                        '0';

    decoded_ld_imm7 <=  '1' when    instr_in(15 downto 10) = "100110"
                            else
                        '0';

    decoded_ld      <=  '1' when    instr_in(15 downto 10) = "001010"
                                    and
                                    instr_in(6 downto 3) = "0011"
                            else
                        '0';

    decoded_jpa     <=  '1' when    instr_in(15 downto 3) = "0000000101001"
                            else
                        '0';

    decoded_nop     <=  '1' when    instr_in(15 downto 0) = X"0000"
                            else
                        '0';

    decoded_cmp     <=  '1' when    instr_in(15 downto 10) = "001101"
                                    and
                                    instr_in(6 downto 3) = "1000"
                            else
                        '0';
                        
    decoded_jrlt    <=  '1' when    instr_in(15 downto 7) = "000010000"
                            else
                        '0';

    ------------Determinação de Sinais de Controle------------

    WEFile          <= '1'  when    decoded_add = '1'   
                                    or
                                    decoded_sub = '1'
                                    or
                                    decoded_ld = '1'
                                    or
                                    decoded_ld_imm7 = '1'
                        else
                        '0';

    WDSrc           <=  "01"    when    decoded_add = '1'
                                        or
                                        decoded_sub = '1'
                                else
                        "10"    when    decoded_ld  = '1'
                                else
                        "11"    when    decoded_ld_imm7 = '1'
                                else
                        "00";
    
    PCSrc <=            '1'     when decoded_jpa = '1'
                        else
                        '0';

    ALUOp   <=          "01"    when decoded_sub = '1' or decoded_cmp = '1'
                                else
                        "00"    when decoded_add = '1'
                                else
                        "00";

    PCImm           <=  '1'     when    decoded_jrlt = '1'
                                        and
                                        c = '1'
                                else
                        '0';

    FLUpdt          <=  '1'     when    decoded_cmp = '1'
                                else
                        '0';
        

end a_s1c17_control_unit;