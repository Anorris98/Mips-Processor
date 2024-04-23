-------------------------------------------------------------------------
-- Drew Kearns
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- ID_EX_pipe.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ID_EX_pipe is
    generic (N : integer := 32);
    port (
        i_CLK            : in std_logic;                        -- Clock input
        i_RST            : in std_logic;                        -- Reset input
        i_WE             : in std_logic;                        -- Write enable (1 when writing, 0 when stalling)
        i_FLUSH          : in std_logic;                        -- FLUSH
        i_ID_halt        : in std_logic;                        -- Halt control signal
        i_ID_STD_Shift   : in std_logic;                        -- STD Shift control signal
        i_ID_ALU_Src     : in std_logic;                        -- ALU Source control signal
        i_ID_ALU_Control : in std_logic_vector(7 downto 0);     -- ALU Control signals
        i_ID_MemToReg    : in std_logic_vector(1 downto 0);     -- MemToReg control signal
        i_ID_MemWrite    : in std_logic;                        -- Memory write control signal
        i_ID_RegWrite    : in std_logic;                        -- Register write control signal
        i_ID_RegDst      : in std_logic_vector(1 downto 0);     -- Register destination control signal
        i_ID_Jump        : in std_logic;                        -- Jump control signal
        i_ID_ext_ctl     : in std_logic;                        -- Sign extension control signal
        i_ID_jal         : in std_logic;                        -- Jump and link write back control signal
        i_ID_jr          : in std_logic;                        -- Jump return control signal
        i_ID_PCP4        : in std_logic_vector(N - 1 downto 0); -- PC+4 value
        i_ID_instr25t21  : in std_logic_vector(4 downto 0);     -- Register Rs address signal
        i_ID_instr20t16  : in std_logic_vector(4 downto 0);     -- Register Rt address signal
        i_ID_instr15t11  : in std_logic_vector(4 downto 0);     -- Register Rd address signal
        i_ID_rs_data_o   : in std_logic_vector(N - 1 downto 0); -- Output from Rs address
        i_ID_rt_data_o   : in std_logic_vector(N - 1 downto 0); -- Output from Rt address
        i_ID_ext_o       : in std_logic_vector(N - 1 downto 0); -- Extension control output
        i_ID_s120_o      : in std_logic_vector(27 downto 0);    -- Instruction [25:0] shifted left 2
        ------------------------------------------------------------------------------------
        -- outputs
        ------------------------------------------------------------------------------------
        o_EX_halt        : out std_logic;                        -- Halt control signal
        o_EX_STD_Shift   : out std_logic;                        -- STD Shift control signal
        o_EX_ALU_Src     : out std_logic;                        -- ALU Source control signal
        o_EX_ALU_Control : out std_logic_vector(7 downto 0);     -- ALU Control signals
        o_EX_MemToReg    : out std_logic_vector(1 downto 0);     -- MemToReg control signal
        o_EX_MemWrite    : out std_logic;                        -- Memory write control signal
        o_EX_RegWrite    : out std_logic;                        -- Register write control signal
        o_EX_RegDst      : out std_logic_vector(1 downto 0);     -- Register destination control signal
        o_EX_Jump        : out std_logic;                        -- Jump control signal
        o_EX_ext_ctl     : out std_logic;                        -- Sign extension control signal
        o_EX_jal         : out std_logic;                        -- Jump and link write back control signal
        o_EX_jr          : out std_logic;                        -- Jump return control signal
        o_EX_PCP4        : out std_logic_vector(N - 1 downto 0); -- PC+4 value
        o_EX_instr25t21  : out std_logic_vector(4 downto 0);     -- Register Rs address signal
        o_EX_instr20t16  : out std_logic_vector(4 downto 0);     -- Register Rt address signal
        o_EX_instr15t11  : out std_logic_vector(4 downto 0);     -- Register Rd address signal
        o_EX_rs_data_o   : out std_logic_vector(N - 1 downto 0); -- Output from Rs address
        o_EX_rt_data_o   : out std_logic_vector(N - 1 downto 0); -- Output from Rt address
        o_EX_ext_o       : out std_logic_vector(N - 1 downto 0); -- Extension control output
        o_EX_s120_o      : out std_logic_vector(27 downto 0)     -- Instruction [25:0] shifted left 2
    );

end ID_EX_pipe;

architecture mixed of ID_EX_pipe is
    -- s_D
    signal s_ID_halt        : std_logic;                        -- Halt control signal
    signal s_ID_STD_Shift   : std_logic;                        -- STD Shift control signal
    signal s_ID_ALU_Src     : std_logic;                        -- ALU Source control signal
    signal s_ID_ALU_Control : std_logic_vector(7 downto 0);     -- ALU Control signals
    signal s_ID_MemToReg    : std_logic_vector(1 downto 0);     -- MemToReg control signal
    signal s_ID_MemWrite    : std_logic;                        -- Memory write control signal
    signal s_ID_RegWrite    : std_logic;                        -- Register write control signal
    signal s_ID_RegDst      : std_logic_vector(1 downto 0);     -- Register destination control signal
    signal s_ID_Jump        : std_logic;                        -- Jump control signal
    signal s_ID_ext_ctl     : std_logic;                        -- Sign extension control signal
    signal s_ID_jal         : std_logic;                        -- Jump and link write back control signal
    signal s_ID_jr          : std_logic;                        -- Jump return control signal
    signal s_ID_PCP4        : std_logic_vector(N - 1 downto 0); -- PC+4 value
    signal s_ID_instr25t21  : std_logic_vector(4 downto 0);     -- Register Rs address signal
    signal s_ID_instr20t16  : std_logic_vector(4 downto 0);     -- Register Rt address signal
    signal s_ID_instr15t11  : std_logic_vector(4 downto 0);     -- Register Rd address signal
    signal s_ID_rs_data_o   : std_logic_vector(N - 1 downto 0); -- Output from Rs address
    signal s_ID_rt_data_o   : std_logic_vector(N - 1 downto 0); -- Output from Rt address
    signal s_ID_ext_o       : std_logic_vector(N - 1 downto 0); -- Extension control output
    signal s_ID_s120_o      : std_logic_vector(27 downto 0);    -- Instruction [25:0] shifted left 2
    -- s_Q
    signal s_EX_halt        : std_logic;                        -- Halt control signal
    signal s_EX_STD_Shift   : std_logic;                        -- STD Shift control signal
    signal s_EX_ALU_Src     : std_logic;                        -- ALU Source control signal
    signal s_EX_ALU_Control : std_logic_vector(7 downto 0);     -- ALU Control signals
    signal s_EX_MemToReg    : std_logic_vector(1 downto 0);     -- MemToReg control signal
    signal s_EX_MemWrite    : std_logic;                        -- Memory write control signal
    signal s_EX_RegWrite    : std_logic;                        -- Register write control signal
    signal s_EX_RegDst      : std_logic_vector(1 downto 0);     -- Register destination control signal
    signal s_EX_Jump        : std_logic;                        -- Jump control signal
    signal s_EX_ext_ctl     : std_logic;                        -- Sign extension control signal
    signal s_EX_jal         : std_logic;                        -- Jump and link write back control signal
    signal s_EX_jr          : std_logic;                        -- Jump return control signal
    signal s_EX_PCP4        : std_logic_vector(N - 1 downto 0); -- PC+4 value
    signal s_EX_instr25t21  : std_logic_vector(4 downto 0);     -- Register Rs address signal
    signal s_EX_instr20t16  : std_logic_vector(4 downto 0);     -- Register Rt address signal
    signal s_EX_instr15t11  : std_logic_vector(4 downto 0);     -- Register Rd address signal
    signal s_EX_rs_data_o   : std_logic_vector(N - 1 downto 0); -- Output from Rs address
    signal s_EX_rt_data_o   : std_logic_vector(N - 1 downto 0); -- Output from Rt address
    signal s_EX_ext_o       : std_logic_vector(N - 1 downto 0); -- Extension control output
    signal s_EX_s120_o      : std_logic_vector(27 downto 0);    -- Instruction [25:0] shifted left 2

begin

    -- The output of the FF is fixed to s_Q
    -- o_Q <= s_Q
    o_EX_halt        <= s_EX_halt;        -- Halt control signal
    o_EX_STD_Shift   <= s_EX_STD_Shift;   -- STD Shift control signal
    o_EX_ALU_Src     <= s_EX_ALU_Src;     -- ALU Source control signal
    o_EX_ALU_Control <= s_EX_ALU_Control; -- ALU Control signals
    o_EX_MemToReg    <= s_EX_MemToReg;    -- MemToReg control signal
    o_EX_MemWrite    <= s_EX_MemWrite;    -- Memory write control signal
    o_EX_RegWrite    <= s_EX_RegWrite;    -- Register write control signal
    o_EX_RegDst      <= s_EX_RegDst;      -- Register destination control signal
    o_EX_Jump        <= s_EX_Jump;        -- Jump control signal
    o_EX_ext_ctl     <= s_EX_ext_ctl;     -- Sign extension control signal
    o_EX_jal         <= s_EX_jal;         -- Jump and link write back control signal
    o_EX_jr          <= s_EX_jr;          -- Jump return control signal
    o_EX_PCP4        <= s_EX_PCP4;        -- PC+4 value
    o_EX_instr25t21  <= s_EX_instr25t21;  -- Register Rs address signal
    o_EX_instr20t16  <= s_EX_instr20t16;  -- Register Rt address signal
    o_EX_instr15t11  <= s_EX_instr15t11;  -- Register Rd address signal
    o_EX_rs_data_o   <= s_EX_rs_data_o;   -- Output from Rs address
    o_EX_rt_data_o   <= s_EX_rt_data_o;   -- Output from Rt address
    o_EX_ext_o       <= s_EX_ext_o;       -- Extension control output
    o_EX_s120_o      <= s_EX_s120_o;      -- Instruction [25:0] shifted left 2

    -- This process handles the asyncrhonous reset and
    -- synchronous write. We want to be able to reset 
    -- our processor's registers so that we minimize
    -- glitchy behavior on startup.
    process (i_CLK, i_RST, i_WE)
    begin
        if (i_RST = '1' or (rising_edge(i_CLK) and i_FLUSH = '1')) then
            s_EX_halt        <= '0';         -- Halt control signal
            s_EX_STD_Shift   <= '0';         -- STD Shift control signal
            s_EX_ALU_Src     <= '0';         -- ALU Source control signal
            s_EX_ALU_Control <= b"00000000"; -- ALU Control signals
            s_EX_MemToReg    <= b"00";       -- MemToReg control signal
            s_EX_MemWrite    <= '0';         -- Memory write control signal
            s_EX_RegWrite    <= '0';         -- Register write control signal
            s_EX_RegDst      <= b"00";       -- Register destination control signal
            s_EX_Jump        <= '0';         -- Jump control signal
            s_EX_ext_ctl     <= '0';         -- Sign extension control signal
            s_EX_jal         <= '0';         -- Jump and link write back control signal
            s_EX_jr          <= '0';         -- Jump return control signal
            s_EX_PCP4        <= x"00000000"; -- PC+4 value
            s_EX_instr25t21  <= b"00000";    -- Register Rs address signal
            s_EX_instr20t16  <= b"00000";    -- Register Rt address signal
            s_EX_instr15t11  <= b"00000";    -- Register Rd address signal
            s_EX_rs_data_o   <= x"00000000"; -- Output from Rs address
            s_EX_rt_data_o   <= x"00000000"; -- Output from Rt address
            s_EX_ext_o       <= x"00000000"; -- Extension control output
            s_EX_s120_o      <= x"0000000";  -- Instruction [25:0] shifted left 2
        elsif (rising_edge(i_CLK) and i_WE = '1') then
            s_EX_halt        <= i_ID_halt;        -- Halt control signal
            s_EX_STD_Shift   <= i_ID_STD_Shift;   -- STD Shift control signal
            s_EX_ALU_Src     <= i_ID_ALU_Src;     -- ALU Source control signal
            s_EX_ALU_Control <= i_ID_ALU_Control; -- ALU Control signals
            s_EX_MemToReg    <= i_ID_MemToReg;    -- MemToReg control signal
            s_EX_MemWrite    <= i_ID_MemWrite;    -- Memory write control signal
            s_EX_RegWrite    <= i_ID_RegWrite;    -- Register write control signal
            s_EX_RegDst      <= i_ID_RegDst;      -- Register destination control signal
            s_EX_Jump        <= i_ID_Jump;        -- Jump control signal
            s_EX_ext_ctl     <= i_ID_ext_ctl;     -- Sign extension control signal
            s_EX_jal         <= i_ID_jal;         -- Jump and link write back control signal
            s_EX_jr          <= i_ID_jr;          -- Jump return control signal
            s_EX_PCP4        <= i_ID_PCP4;        -- PC+4 value
            s_EX_instr25t21  <= i_ID_instr25t21;  -- Register Rt address signal
            s_EX_instr20t16  <= i_ID_instr20t16;  -- Register Rt address signal
            s_EX_instr15t11  <= i_ID_instr15t11;  -- Register Rd address signal
            s_EX_rs_data_o   <= i_ID_rs_data_o;   -- Output from Rs address
            s_EX_rt_data_o   <= i_ID_rt_data_o;   -- Output from Rt address
            s_EX_ext_o       <= i_ID_ext_o;       -- Extension control output
            s_EX_s120_o      <= i_ID_s120_o;      -- Instruction [25:0] shifted left 2
        else
            s_EX_halt        <= s_EX_halt;        -- Halt control signal
            s_EX_STD_Shift   <= s_EX_STD_Shift;   -- STD Shift control signal
            s_EX_ALU_Src     <= s_EX_ALU_Src;     -- ALU Source control signal
            s_EX_ALU_Control <= s_EX_ALU_Control; -- ALU Control signals
            s_EX_MemToReg    <= s_EX_MemToReg;    -- MemToReg control signal
            s_EX_MemWrite    <= s_EX_MemWrite;    -- Memory write control signal
            s_EX_RegWrite    <= s_EX_RegWrite;    -- Register write control signal
            s_EX_RegDst      <= s_EX_RegDst;      -- Register destination control signal
            s_EX_Jump        <= s_EX_Jump;        -- Jump control signal
            s_EX_ext_ctl     <= s_EX_ext_ctl;     -- Sign extension control signal
            s_EX_jal         <= s_EX_jal;         -- Jump and link write back control signal
            s_EX_jr          <= s_EX_jr;          -- Jump return control signal
            s_EX_PCP4        <= s_EX_PCP4;        -- PC+4 value
            s_EX_instr25t21  <= s_EX_instr25t21;  -- Register Rs address signal
            s_EX_instr20t16  <= s_EX_instr20t16;  -- Register Rt address signal
            s_EX_instr15t11  <= s_EX_instr15t11;  -- Register Rd address signal
            s_EX_rs_data_o   <= s_EX_rs_data_o;   -- Output from Rs address
            s_EX_rt_data_o   <= s_EX_rt_data_o;   -- Output from Rt address
            s_EX_ext_o       <= s_EX_ext_o;       -- Extension control output
            s_EX_s120_o      <= s_EX_s120_o;      -- Instruction [25:0] shifted left 2
        end if;

    end process;

end mixed;