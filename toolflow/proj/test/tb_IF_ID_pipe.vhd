-- Drew Kearns
-- tb_IF_ID_pipe.vhd
-------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_IF_ID_pipe is
    generic (gCLK_HPER : time := 50 ns);
end tb_IF_ID_pipe;

architecture behavior of tb_IF_ID_pipe is

    constant N : integer := 32;
    -- Component Declaration for the Unit Under Test (UUT)
    constant cCLK_PER : time := gCLK_HPER * 2;
    component IF_ID_pipe
        generic (N : integer := 32);
        port (
            i_CLK          : in std_logic;                         -- Clock input
            i_RST          : in std_logic;                         -- Reset input
            i_WE           : in std_logic;                         -- Write enable (1 when writing, 0 when stalling)
            i_FLUSH        : in std_logic;                         -- FLUSH
            i_IF_PC_P4     : in std_logic_vector(N - 1 downto 0);  -- PC + 4
            i_IF_instr31t0 : in std_logic_vector(N - 1 downto 0);  -- Entire instruction
            o_ID_PC_P4     : out std_logic_vector(N - 1 downto 0); -- PC + 4
            o_ID_instr31t0 : out std_logic_vector(N - 1 downto 0)  -- Entire instruction
        );
    end component;

    --Inputs
    signal s_CLK          : std_logic;
    signal s_RST          : std_logic;
    signal s_WE           : std_logic;
    signal s_FLUSH        : std_logic;
    signal s_IF_PC_P4     : std_logic_vector(N - 1 downto 0);
    signal s_IF_instr31t0 : std_logic_vector(N - 1 downto 0);

    --Outputs
    signal s_ID_PC_P4     : std_logic_vector(N - 1 downto 0);
    signal s_ID_instr31t0 : std_logic_vector(N - 1 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut : IF_ID_pipe
    generic map(N => N)
    port map(
        i_CLK          => s_CLK,
        i_RST          => s_RST,
        i_WE           => s_WE,
        i_FLUSH        => s_FLUSH,
        i_IF_PC_P4     => s_IF_PC_P4,
        i_IF_instr31t0 => s_IF_instr31t0,
        o_ID_PC_P4     => s_ID_PC_P4,
        o_ID_instr31t0 => s_ID_instr31t0
    );

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

    -----------------------------------------------
    -- Reset data in the registers
    ----------------------------------------------- 
    P_RST : process
    begin
        s_RST <= '1';
        wait for cCLK_PER/2;
        s_RST <= '0';
        wait;
    end process;

    ----------------------------------
    -- Test bench
    ----------------------------------
    P_TB : process
    begin
        s_WE           <= '1';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400004";
        s_IF_instr31t0 <= x"11111111";
        wait for cCLK_PER;

        s_WE           <= '1';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400008";
        s_IF_instr31t0 <= x"22222222";
        wait for cCLK_PER;

        s_WE           <= '0';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400004";
        s_IF_instr31t0 <= x"11111111";
        wait for cCLK_PER;

        s_WE           <= '0';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400008";
        s_IF_instr31t0 <= x"22222222";
        wait for cCLK_PER;

        s_WE           <= '1';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"0040000C";
        s_IF_instr31t0 <= x"33333333";
        wait for cCLK_PER;

        s_WE           <= '1';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400010";
        s_IF_instr31t0 <= x"44444444";
        wait for cCLK_PER;

        s_WE           <= '0';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400020";
        s_IF_instr31t0 <= x"99999999";
        wait for cCLK_PER;

        s_WE           <= '1';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400014";
        s_IF_instr31t0 <= x"55555555";
        wait for cCLK_PER;

        s_WE           <= '1';
        s_FLUSH        <= '1'; -- Should flush regardless of write enable signal bit
        s_IF_PC_P4     <= x"00400014";
        s_IF_instr31t0 <= x"55555555";
        wait for cCLK_PER;

        s_WE           <= '1';
        s_FLUSH        <= '0';
        s_IF_PC_P4     <= x"00400014";
        s_IF_instr31t0 <= x"66666666";
        wait for cCLK_PER;

        s_WE           <= '0';
        s_FLUSH        <= '1'; -- Should flush regardless of write enable signal bit
        s_IF_PC_P4     <= x"00400014";
        s_IF_instr31t0 <= x"55555555";
        wait for cCLK_PER;

        wait;
    end process;

end behavior;