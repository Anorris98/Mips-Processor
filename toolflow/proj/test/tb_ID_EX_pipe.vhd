-- Drew Kearns
-- tb_ID_EX_pipe.vhd
-------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ID_EX_pipe is
    generic (gCLK_HPER : time := 50 ns);
end tb_ID_EX_pipe;

architecture behavior of tb_ID_EX_pipe is

    constant N : integer := 32;
    -- Component Declaration for the Unit Under Test (UUT)
    constant cCLK_PER : time := gCLK_HPER * 2;
    component ID_EX_pipe
        generic (N : integer := 32);
        port (
            i_CLK              : in std_logic;                     -- Clock input
            i_RST              : in std_logic;                     -- Reset input
            i_WE               : in std_logic;                     -- Write enable
            i_ID_halt_c        : in std_logic;                     -- Halt control signal
            i_ID_STD_Shift_c   : in std_logic;                     -- STD Shift control signal
            i_ID_ALU_Src_c     : in std_logic;                     -- ALU Source control signal
            i_ID_ALU_Control_c : in std_logic_vector(7 downto 0);  -- ALU Control signals
            i_ID_MemToReg_c    : in std_logic_vector(1 downto 0);  -- MemToReg control signal
            i_ID_MemWrite_c    : in std_logic;                     -- Memory write control signal
            i_ID_RegWrite_c    : in std_logic;                     -- Register write control signal
            i_ID_RegDst_c      : in std_logic_vector(1 downto 0);  -- Register destination control signal
            i_ID_Jump_c        : in std_logic;                     -- Jump control signal
            i_ID_ext_ctl       : in std_logic;                     -- Sign extension control signal
            i_ID_jal_C         : in std_logic;                     -- Jump and link write back control signal
            i_ID_jr_c          : in std_logic;                     -- Jump return control signal
            i_ID_PCP4          : in std_logic_vector(31 downto 0); -- PC+4 value
            i_ID_instr20t16    : in std_logic_vector(4 downto 0);  -- Register Rt address signal
            i_ID_instr15t11    : in std_logic_vector(4 downto 0);  -- Register Rd address signal
            i_ID_rs_data_o     : in std_logic_vector(31 downto 0); -- Output from Rs address
            i_ID_rt_data_o     : in std_logic_vector(31 downto 0); -- Output from Rt address
            i_ID_ext_o         : in std_logic_vector(31 downto 0); -- Extension control output
            i_ID_s120_o        : in std_logic_vector(27 downto 0); -- Instruction [25:0] shifted left 2
            ------------------------------------------------------------------------------------
            -- outputs
            ------------------------------------------------------------------------------------
            o_EX_halt_c        : out std_logic;                     -- Halt control signal
            o_EX_STD_Shift_c   : out std_logic;                     -- STD Shift control signal
            o_EX_ALU_Src_c     : out std_logic;                     -- ALU Source control signal
            o_EX_ALU_Control_c : out std_logic_vector(7 downto 0);  -- ALU Control signals
            o_EX_MemToReg_c    : out std_logic_vector(1 downto 0);  -- MemToReg control signal
            o_EX_MemWrite_c    : out std_logic;                     -- Memory write control signal
            o_EX_RegWrite_c    : out std_logic;                     -- Register write control signal
            o_EX_RegDst_c      : out std_logic_vector(1 downto 0);  -- Register destination control signal
            o_EX_Jump_c        : out std_logic;                     -- Jump control signal
            o_EX_ext_ctl       : out std_logic;                     -- Sign extension control signal
            o_EX_jal_C         : out std_logic;                     -- Jump and link write back control signal
            o_EX_jr_c          : out std_logic;                     -- Jump return control signal
            o_EX_PCP4          : out std_logic_vector(31 downto 0); -- PC+4 value
            o_EX_instr20t16    : out std_logic_vector(4 downto 0);  -- Register Rt address signal
            o_EX_instr15t11    : out std_logic_vector(4 downto 0);  -- Register Rd address signal
            o_EX_rs_data_o     : out std_logic_vector(31 downto 0); -- Output from Rs address
            o_EX_rt_data_o     : out std_logic_vector(31 downto 0); -- Output from Rt address
            o_EX_ext_o         : out std_logic_vector(31 downto 0); -- Extension control output
            o_EX_s120_o        : out std_logic_vector(27 downto 0)  -- Instruction [25:0] shifted left 2
        );
    end component;

    --Inputs
    signal s_CLK              : std_logic;
    signal s_RST              : std_logic;
    signal s_WE               : std_logic;
    signal s_ID_halt_c        : std_logic;                     -- Halt control signal
    signal s_ID_STD_Shift_c   : std_logic;                     -- STD Shift control signal
    signal s_ID_ALU_Src_c     : std_logic;                     -- ALU Source control signal
    signal s_ID_ALU_Control_c : std_logic_vector(7 downto 0);  -- ALU Control signals
    signal s_ID_MemToReg_c    : std_logic_vector(1 downto 0);  -- MemToReg control signal
    signal s_ID_MemWrite_c    : std_logic;                     -- Memory write control signal
    signal s_ID_RegWrite_c    : std_logic;                     -- Register write control signal
    signal s_ID_RegDst_c      : std_logic_vector(1 downto 0);  -- Register destination control signal
    signal s_ID_Jump_c        : std_logic;                     -- Jump control signal
    signal s_ID_ext_ctl       : std_logic;                     -- Sign extension control signal
    signal s_ID_jal_C         : std_logic;                     -- Jump and link write back control signal
    signal s_ID_jr_c          : std_logic;                     -- Jump return control signal
    signal s_ID_PCP4          : std_logic_vector(31 downto 0); -- PC+4 value
    signal s_ID_instr20t16    : std_logic_vector(4 downto 0);  -- Register Rt address signal
    signal s_ID_instr15t11    : std_logic_vector(4 downto 0);  -- Register Rd address signal
    signal s_ID_rs_data_o     : std_logic_vector(31 downto 0); -- Output from Rs address
    signal s_ID_rt_data_o     : std_logic_vector(31 downto 0); -- Output from Rt address
    signal s_ID_ext_o         : std_logic_vector(31 downto 0); -- Extension control output
    signal s_ID_s120_o        : std_logic_vector(27 downto 0); -- Instruction [25:0] shifted left 2

    --Outputs
    signal s_EX_halt_c        : std_logic;                     -- Halt control signal
    signal s_EX_STD_Shift_c   : std_logic;                     -- STD Shift control signal
    signal s_EX_ALU_Src_c     : std_logic;                     -- ALU Source control signal
    signal s_EX_ALU_Control_c : std_logic_vector(7 downto 0);  -- ALU Control signals
    signal s_EX_MemToReg_c    : std_logic_vector(1 downto 0);  -- MemToReg control signal
    signal s_EX_MemWrite_c    : std_logic;                     -- Memory write control signal
    signal s_EX_RegWrite_c    : std_logic;                     -- Register write control signal
    signal s_EX_RegDst_c      : std_logic_vector(1 downto 0);  -- Register destination control signal
    signal s_EX_Jump_c        : std_logic;                     -- Jump control signal
    signal s_EX_ext_ctl       : std_logic;                     -- Sign extension control signal
    signal s_EX_jal_C         : std_logic;                     -- Jump and link write back control signal
    signal s_EX_jr_c          : std_logic;                     -- Jump return control signal
    signal s_EX_PCP4          : std_logic_vector(31 downto 0); -- PC+4 value
    signal s_EX_instr20t16    : std_logic_vector(4 downto 0);  -- Register Rt address signal
    signal s_EX_instr15t11    : std_logic_vector(4 downto 0);  -- Register Rd address signal
    signal s_EX_rs_data_o     : std_logic_vector(31 downto 0); -- Output from Rs address
    signal s_EX_rt_data_o     : std_logic_vector(31 downto 0); -- Output from Rt address
    signal s_EX_ext_o         : std_logic_vector(31 downto 0); -- Extension control output
    signal s_EX_s120_o        : std_logic_vector(27 downto 0); -- Instruction [25:0] shifted left 2

begin

    -- Instantiate the Unit Under Test (UUT)
    uut : ID_EX_pipe
    generic map(N => N)
    port map(
        i_CLK              => s_CLK,              -- Clock input
        i_RST              => s_RST,              -- Reset input
        i_WE               => s_WE,               -- Write enable
        i_ID_halt_c        => s_ID_halt_c,        -- Halt control signal
        i_ID_STD_Shift_c   => s_ID_STD_Shift_c,   -- STD Shift control signal
        i_ID_ALU_Src_c     => s_ID_ALU_Src_c,     -- ALU Source control signal
        i_ID_ALU_Control_c => s_ID_ALU_Control_c, -- ALU Control signals
        i_ID_MemToReg_c    => s_ID_MemToReg_c,    -- MemToReg control signal
        i_ID_MemWrite_c    => s_ID_MemWrite_c,    -- Memory write control signal
        i_ID_RegWrite_c    => s_ID_RegWrite_c,    -- Register write control signal
        i_ID_RegDst_c      => s_ID_RegDst_c,      -- Register destination control signal
        i_ID_Jump_c        => s_ID_Jump_c,        -- Jump control signal
        i_ID_ext_ctl       => s_ID_ext_ctl,       -- Sign extension control signal
        i_ID_jal_C         => s_ID_jal_C,         -- Jump and link write back control signal
        i_ID_jr_c          => s_ID_jr_c,          -- Jump return control signal
        i_ID_PCP4          => s_ID_PCP4,          -- PC+4 value
        i_ID_instr20t16    => s_ID_instr20t16,    -- Register Rt address signal
        i_ID_instr15t11    => s_ID_instr15t11,    -- Register Rd address signal
        i_ID_rs_data_o     => s_ID_rs_data_o,     -- Output from Rs address
        i_ID_rt_data_o     => s_ID_rt_data_o,     -- Output from Rt address
        i_ID_ext_o         => s_ID_ext_o,         -- Extension control output
        i_ID_s120_o        => s_ID_s120_o,        -- Instruction [25:0] shifted left 2
        ------------------------------------------------------------------------------------
        -- outputs
        ------------------------------------------------------------------------------------
        o_EX_halt_c        => s_EX_halt_c,        -- Halt control signal
        o_EX_STD_Shift_c   => s_EX_STD_Shift_c,   -- STD Shift control signal
        o_EX_ALU_Src_c     => s_EX_ALU_Src_c,     -- ALU Source control signal
        o_EX_ALU_Control_c => s_EX_ALU_Control_c, -- ALU Control signals
        o_EX_MemToReg_c    => s_EX_MemToReg_c,    -- MemToReg control signal
        o_EX_MemWrite_c    => s_EX_MemWrite_c,    -- Memory write control signal
        o_EX_RegWrite_c    => s_EX_RegWrite_c,    -- Register write control signal
        o_EX_RegDst_c      => s_EX_RegDst_c,      -- Register destination control signal
        o_EX_Jump_c        => s_EX_Jump_c,        -- Jump control signal
        o_EX_ext_ctl       => s_EX_ext_ctl,       -- Sign extension control signal
        o_EX_jal_C         => s_EX_jal_C,         -- Jump and link write back control signal
        o_EX_jr_c          => s_EX_jr_c,          -- Jump return control signal
        o_EX_PCP4          => s_EX_PCP4,          -- PC+4 value
        o_EX_instr20t16    => s_EX_instr20t16,    -- Register Rt address signal
        o_EX_instr15t11    => s_EX_instr15t11,    -- Register Rd address signal
        o_EX_rs_data_o     => s_EX_rs_data_o,     -- Output from Rs address
        o_EX_rt_data_o     => s_EX_rt_data_o,     -- Output from Rt address
        o_EX_ext_o         => s_EX_ext_o,         -- Extension control output
        o_EX_s120_o        => s_EX_s120_o         -- Instruction [25:0] shifted left 2
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
        s_WE               <= '1';
        s_ID_halt_c        <= '1';
        s_ID_STD_Shift_c   <= '1';
        s_ID_ALU_Src_c     <= '1';
        s_ID_ALU_Control_c <= x"FF";
        s_ID_MemToReg_c    <= b"11";
        s_ID_MemWrite_c    <= '1';
        s_ID_RegWrite_c    <= '1';
        s_ID_RegDst_c      <= b"11";
        s_ID_Jump_c        <= '1';
        s_ID_ext_ctl       <= '1';
        s_ID_jal_C         <= '1';
        s_ID_jr_c          <= '1';
        s_ID_PCP4          <= x"00400008";
        s_ID_instr20t16    <= b"11111";
        s_ID_instr15t11    <= b"11111";
        s_ID_rs_data_o     <= x"FFFFFFFF";
        s_ID_rt_data_o     <= x"FFFFFFFF";
        s_ID_ext_o         <= x"FFFFFFFF";
        s_ID_s120_o        <= x"FFFFFFF";
        wait for cCLK_PER;

        s_WE               <= '1';
        s_ID_halt_c        <= '0';
        s_ID_STD_Shift_c   <= '0';
        s_ID_ALU_Src_c     <= '0';
        s_ID_ALU_Control_c <= x"00";
        s_ID_MemToReg_c    <= b"00";
        s_ID_MemWrite_c    <= '0';
        s_ID_RegWrite_c    <= '0';
        s_ID_RegDst_c      <= b"00";
        s_ID_Jump_c        <= '0';
        s_ID_ext_ctl       <= '0';
        s_ID_jal_C         <= '0';
        s_ID_jr_c          <= '0';
        s_ID_PCP4          <= x"00400008";
        s_ID_instr20t16    <= b"00000";
        s_ID_instr15t11    <= b"00000";
        s_ID_rs_data_o     <= x"00000000";
        s_ID_rt_data_o     <= x"00000000";
        s_ID_ext_o         <= x"00000000";
        s_ID_s120_o        <= x"0000000";
        wait for cCLK_PER;

        s_WE               <= '0';
        s_ID_halt_c        <= '1';
        s_ID_STD_Shift_c   <= '1';
        s_ID_ALU_Src_c     <= '1';
        s_ID_ALU_Control_c <= x"FF";
        s_ID_MemToReg_c    <= b"11";
        s_ID_MemWrite_c    <= '1';
        s_ID_RegWrite_c    <= '1';
        s_ID_RegDst_c      <= b"11";
        s_ID_Jump_c        <= '1';
        s_ID_ext_ctl       <= '1';
        s_ID_jal_C         <= '1';
        s_ID_jr_c          <= '1';
        s_ID_PCP4          <= x"00400008";
        s_ID_instr20t16    <= b"11111";
        s_ID_instr15t11    <= b"11111";
        s_ID_rs_data_o     <= x"FFFFFFFF";
        s_ID_rt_data_o     <= x"FFFFFFFF";
        s_ID_ext_o         <= x"FFFFFFFF";
        s_ID_s120_o        <= x"FFFFFFF";
        wait for cCLK_PER;

        s_WE               <= '0';
        s_ID_halt_c        <= '0';
        s_ID_STD_Shift_c   <= '0';
        s_ID_ALU_Src_c     <= '0';
        s_ID_ALU_Control_c <= x"00";
        s_ID_MemToReg_c    <= b"00";
        s_ID_MemWrite_c    <= '0';
        s_ID_RegWrite_c    <= '0';
        s_ID_RegDst_c      <= b"00";
        s_ID_Jump_c        <= '0';
        s_ID_ext_ctl       <= '0';
        s_ID_jal_C         <= '0';
        s_ID_jr_c          <= '0';
        s_ID_PCP4          <= x"00400008";
        s_ID_instr20t16    <= b"00000";
        s_ID_instr15t11    <= b"00000";
        s_ID_rs_data_o     <= x"00000000";
        s_ID_rt_data_o     <= x"00000000";
        s_ID_ext_o         <= x"00000000";
        s_ID_s120_o        <= x"0000000";
        wait for cCLK_PER;

        s_WE               <= '1';
        s_ID_halt_c        <= '1';
        s_ID_STD_Shift_c   <= '1';
        s_ID_ALU_Src_c     <= '1';
        s_ID_ALU_Control_c <= x"FF";
        s_ID_MemToReg_c    <= b"11";
        s_ID_MemWrite_c    <= '1';
        s_ID_RegWrite_c    <= '1';
        s_ID_RegDst_c      <= b"11";
        s_ID_Jump_c        <= '1';
        s_ID_ext_ctl       <= '1';
        s_ID_jal_C         <= '1';
        s_ID_jr_c          <= '1';
        s_ID_PCP4          <= x"00400008";
        s_ID_instr20t16    <= b"11111";
        s_ID_instr15t11    <= b"11111";
        s_ID_rs_data_o     <= x"FFFFFFFF";
        s_ID_rt_data_o     <= x"FFFFFFFF";
        s_ID_ext_o         <= x"FFFFFFFF";
        s_ID_s120_o        <= x"FFFFFFF";
        wait for cCLK_PER;

        wait;
    end process;

end behavior;