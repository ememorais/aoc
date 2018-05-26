library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
    port(
        clk : in std_logic;
        rst : in std_logic
    );
end cpu;

architecture a_cpu of cpu is

    component s1c17_register is
        port (
            clk      : in    std_logic;
            rst      : in    std_logic;
            wen      : in    std_logic;
            data_in  : in    unsigned(23 downto 0);
            data_out : out   unsigned(23 downto 0)
          );
    end component s1c17_register;

    component s1c17_status_register is
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            wen          : in  std_logic;
            c_in, z_in   : in  std_logic;
            c_out, z_out : out std_logic
        );
    end component s1c17_status_register;

    component s1c17_rom is
        port(
            clk      : in  std_logic;
            addr     : in  unsigned(23 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component s1c17_rom;

    component s1c17_register_file is
        port (
            clk : in std_logic;
            rst : in std_logic;
            we3 : in std_logic;

            a1  : in unsigned(2 downto 0);
            a2  : in unsigned(2 downto 0);
            a3  : in unsigned(2 downto 0);

            wd3 : in  unsigned(23 downto 0);
            rd1 : out unsigned(23 downto 0);
            rd2 : out unsigned(23 downto 0)
        );
    end component s1c17_register_file;

    component s1c17_alu is
        port (
            op          : in unsigned(1 downto 0);
            in_a, in_b  : in unsigned(23 downto 0);
            zf, cf      : out std_logic;
            out_value   : out unsigned(23 downto 0)
        );
    end component s1c17_alu;

    signal IRWrite          : std_logic := '0';
    signal PCWrite          : std_logic := '0';
    signal DRWrite          : std_logic := '0';
    signal DRSrc            : unsigned(1 downto 0) := "00";
    signal ALUOp            : unsigned(1 downto 0);
    signal PCSrc            : std_logic := '0';
    signal SRWrite          : std_logic := '0';

    signal state_s          : unsigned(1 downto 0) := "00";



    signal pc_in_s          : unsigned(23 downto 0) := X"000000";
    signal pc_out_s         : unsigned(23 downto 0) := X"000000";

    signal instr_in_s       : unsigned(23 downto 0) := X"000000";
    signal instr_out_s      : unsigned(23 downto 0) := X"000000";

    signal a_in_s           : unsigned(23 downto 0) := X"000000";
    signal a_out_s          : unsigned(23 downto 0) := X"000000";

    signal b_in_s           : unsigned(23 downto 0) := X"000000";
    signal b_out_s          : unsigned(23 downto 0) := X"000000";

    signal rom_in_s         : unsigned(23 downto 0) := X"000000";
    signal rom_out_s        : unsigned(15 downto 0) := X"0000";

    signal file_a1_s        : unsigned(2 downto 0)  := "000";
    signal file_a2_s        : unsigned(2 downto 0)  := "000";

    signal file_rd1_s       : unsigned(23 downto 0) := X"000000";
    signal file_rd2_s       : unsigned(23 downto 0) := X"000000";

    signal file_wd3_s       : unsigned(23 downto 0) := X"000000";


    signal imm7_s           : unsigned(6 downto 0)  := "0000000";
    signal imm7_ext_s       : unsigned(23 downto 0) := X"000000";
    signal imm7_ext_out_s   : unsigned(23 downto 0) := X"000000";

    signal alu_out_s        : unsigned(23 downto 0) := X"000000";
    signal alu_zf_s         : std_logic;
    signal alu_cf_s         : std_logic;

    signal status_cf_s, status_zf_s : std_logic;

    signal  decoded_add,
            decoded_sub,
            decoded_ld,
            decoded_ld_imm7,
            decoded_jpa,
            decoded_nop,
            decoded_cmp      : std_logic;


begin

    ------------SINAIS DE DECODIFICACAO------------

    decoded_add <=      '1' when    rom_out_s(15 downto 10) = "001110"
                                    and
                                    rom_out_s(6 downto 3)   = "1000"
                            else
                        '0';

    decoded_sub <=      '1' when    rom_out_s(15 downto 10) = "001110"
                                    and
                                    rom_out_s(6 downto 3)   = "1010"
                            else
                        '0';


    decoded_ld_imm7 <=  '1' when    rom_out_s(15 downto 10) = "100110"
                            else
                        '0';

    decoded_ld      <=  '1' when    rom_out_s(15 downto 10) = "001010"
                                    and
                                    rom_out_s(6 downto 3) = "0011"
                            else
                        '0';

    decoded_jpa     <=  '1' when    rom_out_s(15 downto 3) = "0000000101001"
                            else
                        '0';

    decoded_nop     <=  '1' when    rom_out_s(15 downto 0) = X"0000"
                            else
                        '0';

    decoded_cmp     <=  '1' when    rom_out_s(15 downto 10) = "001101"
                                    and
                                    rom_out_s(6 downto 3) = "1000"
                            else
                        '0';
                                

    ------------SINAIS DE CONTROLE------------

    IRWrite <= '1'  when state_s = "00" and decoded_nop = '0' else '0';

    --PCWrite e DRWrite ligados apenas no estado EXECUTE
    PCWRite <= '1'  when state_s = "10" else '0';

    --DRWrite checa se está em EXECUTE e se é uma instrucao que escreve dados
    DRWRite <= '1'      when    state_s = "10"
                                and
                                (decoded_add = '1'
                                    or
                                decoded_sub = '1'
                                    or
                                decoded_ld = '1'
                                    or
                                decoded_ld_imm7 = '1')
                        else
                '0';

    SRWrite <= '1'      when    state_s = "10" 
                                and 
                                decoded_nop = '0' 
                        else 
                '0';

    --DRSrc recebe '01' quando a instrucao 'add' e encontrada
    DRSrc   <=  "01"    when    decoded_add = '1'
                                or
                                decoded_sub = '1'
                        else
                "10"    when    decoded_ld  = '1'
                        else
                "11"    when    decoded_ld_imm7 = '1'
                        else
                "00";

    --ALUOP = soma quando add, subtracao quando sub ou cmp
    ALUOp   <=  "01"    when decoded_sub = '1' or decoded_cmp = '1'
                        else
                "00"    when decoded_add = '1'
                        else
                "00";

    PCSrc <=    '1'     when decoded_jpa = '1'
                        else
                '0';


    pc_in_s <= b_out_s when PCSrc = '1' else (pc_out_s + 1);

    rom_in_s <= pc_out_s;

    instr_in_s <= resize(rom_out_s, 24);

    file_a1_s <= instr_out_s(9 downto 7);

    file_a2_s <= instr_out_s(2 downto 0);

    imm7_s <= instr_out_s(6 downto 0);

    imm7_ext_s <= unsigned(resize(signed(imm7_s), 24));

    a_in_s <= file_rd1_s;
    b_in_s <= file_rd2_s;

    file_wd3_s <=   alu_out_s       when DRSrc = "01"
                                    else
                    b_out_s         when DRSrc = "10"
                                    else
                    imm7_ext_out_s  when DRSrc = "11"
                                    else
                    X"000000";


    --TODO: colocar flags no status_in


    program_counter: s1c17_register
        port map(
            clk      => clk,
            rst      => rst,
            wen      => PCWrite,
            data_in  => pc_in_s,
            data_out => pc_out_s
        );

    status_register: s1c17_status_register
        port map(
            clk => clk,
            rst => rst,
            wen => SRWrite,
            c_in => alu_cf_s,
            z_in => alu_zf_s,
            c_out => status_cf_s,
            z_out => status_zf_s
        );

    instr_register: s1c17_register
        port map(
            clk      => clk,
            rst      => rst,
            wen      => IRWrite,
            data_in  => instr_in_s,
            data_out => instr_out_s
        );

    a_register: s1c17_register
        port map(
            clk      => clk,
            rst      => rst,
            wen      => '1',
            data_in  => a_in_s,
            data_out => a_out_s
        );

    b_register: s1c17_register
        port map(
            clk      => clk,
            rst      => rst,
            wen      => '1',
            data_in  => b_in_s,
            data_out => b_out_s
        );

    imm_register: s1c17_register
        port map(
            clk => clk,
            rst => rst,
            wen => '1',
            data_in => imm7_ext_s,
            data_out => imm7_ext_out_s
        );

    rom : s1c17_rom
        port map(
            clk => clk,
            addr => rom_in_s,
            data_out => rom_out_s
        );

    register_file : s1c17_register_file
        port map(
            clk => clk,
            rst => rst,
            we3 => DRWrite,
            a1 => file_a1_s,
            a2 => file_a2_s,
            a3 => file_a1_s,
            wd3 => file_wd3_s,
            rd1 => file_rd1_s,
            rd2 => file_rd2_s
        );

    alu : s1c17_alu
        port map (
            op => ALUOp,
            in_a => a_out_s,
            in_b => b_out_s,
            zf   => alu_zf_s,
            cf   => alu_cf_s,
            out_value => alu_out_s
        );


end a_cpu;