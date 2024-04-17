-- Drew Kearns
-- tb_MEM_WB_pipe.vhd
-------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_MEM_WB_pipe is
    generic (gCLK_HPER : time := 50 ns);
end tb_MEM_WB_pipe;

architecture behavior of tb_MEM_WB_pipe is

    constant N : integer := 32;
    -- Component Declaration for the Unit Under Test (UUT)
    constant cCLK_PER : time := gCLK_HPER * 2;
    component MEM_WB_pipe
        generic (N : integer := 32);
        port (
            i_CLK           : in std_logic;                        -- Clock input
            i_RST           : in std_logic;                        -- Reset input
            i_WE            : in std_logic;                        -- Write enable
            i_MEM_halt      : in std_logic;                        -- Halt control signal
            i_MEM_MemToReg  : in std_logic_vector(1 downto 0);     -- MemToReg control signal
            i_MEM_RegWrite  : in std_logic;                        -- Register write control signal
            i_MEM_jal       : in std_logic;                        -- Jump and link write back control signal
            i_MEM_PCP4      : in std_logic_vector(N - 1 downto 0); -- PC+4 value
            i_MEM_RegWrAddr : in std_logic_vector(4 downto 0);     -- Write address
            i_MEM_Dmem_Addr : in std_logic_vector(N - 1 downto 0); -- Output from the ALU
            i_MEM_Dmem_out  : in std_logic_vector(N - 1 downto 0); -- Output from DMEM
            i_MEM_Dmem_Lb   : in std_logic_vector(N - 1 downto 0); -- Output from byte decoder
            i_MEM_Dmem_Lh   : in std_logic_vector(N - 1 downto 0); -- Output from word decoder
            ------------------------------------------------------------------------------------
            -- outputs
            ------------------------------------------------------------------------------------
            o_WB_halt      : out std_logic;                        -- Halt control signal
            o_WB_MemToReg  : out std_logic_vector(1 downto 0);     -- MemToReg control signal
            o_WB_RegWrite  : out std_logic;                        -- Register write control signal
            o_WB_jal       : out std_logic;                        -- Jump and link write back control signal
            o_WB_PCP4      : out std_logic_vector(N - 1 downto 0); -- PC+4 value
            o_WB_RegWrAddr : out std_logic_vector(4 downto 0);     -- Write address
            o_WB_Dmem_Addr : out std_logic_vector(N - 1 downto 0); -- Output from the ALU
            o_WB_Dmem_out  : out std_logic_vector(N - 1 downto 0); -- Output from DMEM
            o_WB_Dmem_Lb   : out std_logic_vector(N - 1 downto 0); -- Output from byte decoder
            o_WB_Dmem_Lh   : out std_logic_vector(N - 1 downto 0)  -- Output from word decoder
        );
    end component;

    --Inputs
    signal s_CLK           : std_logic;
    signal s_RST           : std_logic;
    signal s_WE            : std_logic;
    signal s_MEM_halt      : std_logic;                        -- Halt control signal
    signal s_MEM_MemToReg  : std_logic_vector(1 downto 0);     -- MemToReg control signal
    signal s_MEM_RegWrite  : std_logic;                        -- Register write control signal
    signal s_MEM_jal       : std_logic;                        -- Jump and link write back control signal
    signal s_MEM_PCP4      : std_logic_vector(N - 1 downto 0); -- PC+4 value
    signal s_MEM_RegWrAddr : std_logic_vector(4 downto 0);     -- Write address
    signal s_MEM_Dmem_Addr : std_logic_vector(N - 1 downto 0); -- Output from the ALU
    signal s_MEM_Dmem_out  : std_logic_vector(N - 1 downto 0); -- Output from DMEM
    signal s_MEM_Dmem_Lb   : std_logic_vector(N - 1 downto 0); -- Output from byte decoder
    signal s_MEM_Dmem_Lh   : std_logic_vector(N - 1 downto 0); -- Output from word decoder

    --Outputs
    signal s_WB_halt      : std_logic;                        -- Halt control signal
    signal s_WB_MemToReg  : std_logic_vector(1 downto 0);     -- MemToReg control signal
    signal s_WB_RegWrite  : std_logic;                        -- Register write control signal
    signal s_WB_jal       : std_logic;                        -- Jump and link write back control signal
    signal s_WB_PCP4      : std_logic_vector(N - 1 downto 0); -- PC+4 value
    signal s_WB_RegWrAddr : std_logic_vector(4 downto 0);     -- Write address
    signal s_WB_Dmem_Addr : std_logic_vector(N - 1 downto 0); -- Output from the ALU
    signal s_WB_Dmem_out  : std_logic_vector(N - 1 downto 0); -- Output from DMEM
    signal s_WB_Dmem_Lb   : std_logic_vector(N - 1 downto 0); -- Output from byte decoder
    signal s_WB_Dmem_Lh   : std_logic_vector(N - 1 downto 0); -- Output from word decoder

begin

    -- Instantiate the Unit Under Test (UUT)
    uut : MEM_WB_pipe
    generic map(N => N)
    port map(
        i_CLK           => s_CLK,
        i_RST           => s_RST,
        i_WE            => s_WE,
        i_MEM_halt      => s_MEM_halt,      -- Halt control signal
        i_MEM_MemToReg  => s_MEM_MemToReg,  -- MemToReg control signal
        i_MEM_RegWrite  => s_MEM_RegWrite,  -- Register write control signal
        i_MEM_jal       => s_MEM_jal,       -- Jump and link write back control signal
        i_MEM_PCP4      => s_MEM_PCP4,      -- PC+4 value
        i_MEM_RegWrAddr => s_MEM_RegWrAddr, -- Write address
        i_MEM_Dmem_Addr => s_MEM_Dmem_Addr, -- Output from the ALU
        i_MEM_Dmem_out  => s_MEM_Dmem_out,  -- Output from DMEM
        i_MEM_Dmem_Lb   => s_MEM_Dmem_Lb,   -- Output from byte decoder
        i_MEM_Dmem_Lh   => s_MEM_Dmem_Lh,    -- Output from word decoder
        ------------------------------------------------------------------------------------
        -- outputs
        ------------------------------------------------------------------------------------
        o_WB_halt      => s_WB_halt,      -- Halt control signal
        o_WB_MemToReg  => s_WB_MemToReg,  -- MemToReg control signal
        o_WB_RegWrite  => s_WB_RegWrite,  -- Register write control signal
        o_WB_jal       => s_WB_jal,       -- Jump and link write back control signal
        o_WB_PCP4      => s_WB_PCP4,      -- PC+4 value
        o_WB_RegWrAddr => s_WB_RegWrAddr, -- Write address
        o_WB_Dmem_Addr => s_WB_Dmem_Addr, -- Output from the ALU
        o_WB_Dmem_out  => s_WB_Dmem_out,  -- Output from DMEM
        o_WB_Dmem_Lb   => s_WB_Dmem_Lb,   -- Output from byte decoder
        o_WB_Dmem_Lh   => s_WB_Dmem_Lh    -- Output from word decoder
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
        s_WE            <= '1';
        s_MEM_halt      <= '1';
        s_MEM_MemToReg  <= b"11";
        s_MEM_RegWrite  <= '1';
        s_MEM_jal       <= '1';
        s_MEM_PCP4      <= x"FFFFFFFF";
        s_MEM_RegWrAddr <= b"11111";
        s_MEM_Dmem_Addr <= x"FFFFFFFF";
        s_MEM_Dmem_out  <= x"FFFFFFFF";
        s_MEM_Dmem_Lb   <= x"FFFFFFFF";
        s_MEM_Dmem_Lh   <= x"FFFFFFFF";
        wait for cCLK_PER;

        s_WE            <= '1';
        s_MEM_halt      <= '0';
        s_MEM_MemToReg  <= b"00";
        s_MEM_RegWrite  <= '0';
        s_MEM_jal       <= '0';
        s_MEM_PCP4      <= x"00000000";
        s_MEM_RegWrAddr <= b"00000";
        s_MEM_Dmem_Addr <= x"00000000";
        s_MEM_Dmem_out  <= x"00000000";
        s_MEM_Dmem_Lb   <= x"00000000";
        s_MEM_Dmem_Lh   <= x"00000000";
        wait for cCLK_PER;

        s_WE            <= '0';
        s_MEM_halt      <= '1';
        s_MEM_MemToReg  <= b"11";
        s_MEM_RegWrite  <= '1';
        s_MEM_jal       <= '1';
        s_MEM_PCP4      <= x"FFFFFFFF";
        s_MEM_RegWrAddr <= b"11111";
        s_MEM_Dmem_Addr <= x"FFFFFFFF";
        s_MEM_Dmem_out  <= x"FFFFFFFF";
        s_MEM_Dmem_Lb   <= x"FFFFFFFF";
        s_MEM_Dmem_Lh   <= x"FFFFFFFF";
        wait for cCLK_PER;

        s_WE            <= '0';
        s_MEM_halt      <= '0';
        s_MEM_MemToReg  <= b"00";
        s_MEM_RegWrite  <= '0';
        s_MEM_jal       <= '0';
        s_MEM_PCP4      <= x"00000000";
        s_MEM_RegWrAddr <= b"00000";
        s_MEM_Dmem_Addr <= x"00000000";
        s_MEM_Dmem_out  <= x"00000000";
        s_MEM_Dmem_Lb   <= x"00000000";
        s_MEM_Dmem_Lh   <= x"00000000";
        wait for cCLK_PER;

        s_WE            <= '1';
        s_MEM_halt      <= '1';
        s_MEM_MemToReg  <= b"11";
        s_MEM_RegWrite  <= '1';
        s_MEM_jal       <= '1';
        s_MEM_PCP4      <= x"FFFFFFFF";
        s_MEM_RegWrAddr <= b"11111";
        s_MEM_Dmem_Addr <= x"FFFFFFFF";
        s_MEM_Dmem_out  <= x"FFFFFFFF";
        s_MEM_Dmem_Lb   <= x"FFFFFFFF";
        s_MEM_Dmem_Lh   <= x"FFFFFFFF";
        wait for cCLK_PER;

        wait;
    end process;

end behavior;