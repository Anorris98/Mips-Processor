-- Drew Kearns
-- tb_fetchLogic.vhd
-------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fetch_logic is
    generic (gCLK_HPER : time := 50 ns);
end tb_fetch_logic;

architecture behavior of tb_fetch_logic is

    constant N : integer := 32;
    -- Component Declaration for the Unit Under Test (UUT)
    constant cCLK_PER : time := gCLK_HPER * 2;
    component fetchLogic
        generic (N : integer := 32);
        port (
            i_jump_C : in std_logic;
            i_jal_C : in std_logic;
            i_jr_ra_C : in std_logic;
            i_CLK : in std_logic;
            i_RST : in std_logic;
            i_w_branch_n_ALUo : in std_logic;
            i_instr_25t0 : in std_logic_vector(25 downto 0);
            i_ext_imm : in std_logic_vector(N - 1 downto 0);
            i_jr_ra_pc_next : in std_logic_vector(N - 1 downto 0);
            o_pc_p4 : out std_logic_vector(N - 1 downto 0);
            o_pc_next : out std_logic_vector(N - 1 downto 0));
    end component;

    --Inputs
    signal s_jump_C : std_logic;
    signal s_jal_C : std_logic;
    signal s_jr_ra_C : std_logic;
    signal s_CLK : std_logic;
    signal s_RST : std_logic;
    signal s_w_branch_n_ALUo : std_logic;
    signal s_instr_25t0 : std_logic_vector(25 downto 0);
    signal s_ext_imm : std_logic_vector(N - 1 downto 0);
    signal s_jr_ra_pc_next : std_logic_vector(N - 1 downto 0);

    --Outputs
    signal s_o_pc_p4 : std_logic_vector(N - 1 downto 0);
    signal s_o_pc_next : std_logic_vector(N - 1 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut : fetchLogic
    generic map(N => N)
    port map(
        i_jump_C => s_jump_C,
        i_jal_C => s_jal_C,
        i_jr_ra_C => s_jr_ra_C,
        i_CLK => s_CLK,
        i_RST => s_RST,
        i_w_branch_n_ALUo => s_w_branch_n_ALUo,
        i_instr_25t0 => s_instr_25t0,
        i_ext_imm => s_ext_imm,
        i_jr_ra_pc_next => s_jr_ra_pc_next,
        o_pc_p4 => s_o_pc_p4,
        o_pc_next => s_o_pc_next);

    -- This process sets the clock value (low for gCLK_HPER, then high
    -- for gCLK_HPER). Absent a "wait" command, processes restart 
    -- at the beginning once they have reached the final statement.
    P_CLK : process
    begin
        s_CLK <= '0';
        wait for gCLK_HPER;
        s_CLK <= '1';
        wait for gCLK_HPER;
    end process;

    ----------------------------------
    -- Test bench
    ----------------------------------
    P_TB : process
    begin

        s_RST <= '1';
        wait for cCLK_PER/2;
        s_RST <= '0';
        -- o_pc_next = 0x00400000

        s_jump_C <= '0';
        s_jal_C <= '0';
        s_jr_ra_C <= '0';
        s_w_branch_n_ALUo <= '0';
        s_instr_25t0 <= b"00" & x"000000"; -- b"00" bits 25-24, x"000000" bits 23-0
        s_ext_imm <= x"00000000";
        s_jr_ra_pc_next <= x"00000000";
        -- o_pc_next = 0x00400004

        wait;
    end process;

end behavior;