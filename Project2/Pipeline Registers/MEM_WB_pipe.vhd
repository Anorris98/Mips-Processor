-------------------------------------------------------------------------
-- Drew Kearns
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- MEM_WB_pipe.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MEM_WB_pipe is
    generic (N : integer := 32);
    port (
        i_CLK           : in std_logic;                     -- Clock input
        i_RST           : in std_logic;                     -- Reset input
        i_WE            : in std_logic;                     -- Write enable
        i_MEM_halt      : in std_logic;                     -- Halt control signal
        i_MEM_MemToReg  : in std_logic_vector(1 downto 0);  -- MemToReg control signal
        i_MEM_RegWrite  : in std_logic;                     -- Register write control signal
        i_MEM_jal       : in std_logic;                     -- Jump and link write back control signal
        i_MEM_PCP4      : in std_logic_vector(31 downto 0); -- PC+4 value
        i_MEM_RegWrAddr : in std_logic_vector(4 downto 0);  -- Write address
        i_MEM_Dmem_Addr : in std_logic_vector(31 downto 0); -- Output from the ALU
        ------------------------------------------------------------------------------------
        -- outputs
        ------------------------------------------------------------------------------------
        o_WB_halt      : out std_logic;                     -- Halt control signal
        o_WB_MemToReg  : out std_logic_vector(1 downto 0);  -- MemToReg control signal
        o_WB_RegWrite  : out std_logic;                     -- Register write control signal
        o_WB_jal       : out std_logic;                     -- Jump and link write back control signal
        o_WB_PCP4      : out std_logic_vector(31 downto 0); -- PC+4 value
        o_WB_RegWrAddr : out std_logic_vector(4 downto 0);  -- Write address
        o_WB_Dmem_Addr : out std_logic_vector(31 downto 0)  -- Output from the ALU
    );

end MEM_WB_pipe;

architecture mixed of MEM_WB_pipe is
    -- s_D
    signal s_MEM_halt      : std_logic;                     -- Halt control signal
    signal s_MEM_MemToReg  : std_logic_vector(1 downto 0);  -- MemToReg control signal
    signal s_MEM_RegWrite  : std_logic;                     -- Register write control signal
    signal s_MEM_jal       : std_logic;                     -- Jump and link write back control signal
    signal s_MEM_PCP4      : std_logic_vector(31 downto 0); -- PC+4 value
    signal s_MEM_RegWrAddr : std_logic_vector(4 downto 0);  -- Write address
    signal s_MEM_Dmem_Addr : std_logic_vector(31 downto 0); -- Output from the ALU
    -- s_Q
    signal s_WB_halt      : std_logic;                     -- Halt control signal
    signal s_WB_MemToReg  : std_logic_vector(1 downto 0);  -- MemToReg control signal
    signal s_WB_RegWrite  : std_logic;                     -- Register write control signal
    signal s_WB_jal       : std_logic;                     -- Jump and link write back control signal
    signal s_WB_PCP4      : std_logic_vector(31 downto 0); -- PC+4 value
    signal s_WB_RegWrAddr : std_logic_vector(4 downto 0);  -- Write address
    signal s_WB_Dmem_Addr : std_logic_vector(31 downto 0); -- Output from the ALU

begin

    -- The output of the FF is fixed to s_Q
    -- o_Q <= s_Q
    o_WB_halt      <= s_WB_halt;      -- Halt control signal
    o_WB_MemToReg  <= s_WB_MemToReg;  -- MemToReg control signal
    o_WB_RegWrite  <= s_WB_RegWrite;  -- Register write control signal
    o_WB_jal       <= s_WB_jal;       -- Jump and link write back control signal
    o_WB_PCP4      <= s_WB_PCP4;      -- PC+4 value
    o_WB_RegWrAddr <= s_WB_RegWrAddr; -- Write address
    o_WB_Dmem_Addr <= s_WB_Dmem_Addr; -- Output from the ALU

    -- This process handles the asyncrhonous reset and
    -- synchronous write. We want to be able to reset 
    -- our processor's registers so that we minimize
    -- glitchy behavior on startup.
    process (i_CLK, i_RST, i_WE)
    begin
        if (i_RST = '1') then
            s_WB_halt      <= '0';         -- Halt control signal
            s_WB_MemToReg  <= b"00";       -- MemToReg control signal
            s_WB_RegWrite  <= '0';         -- Register write control signal
            s_WB_jal       <= '0';         -- Jump and link write back control signal
            s_WB_PCP4      <= x"00400004"; -- PC+4 value
            s_WB_RegWrAddr <= b"00000";    -- Write address
            s_WB_Dmem_Addr <= x"00000000"; -- Output from the ALU
        elsif (rising_edge(i_CLK) and i_WE = '1') then
            s_WB_halt      <= i_MEM_halt;      -- Halt control signal
            s_WB_MemToReg  <= i_MEM_MemToReg;  -- MemToReg control signal
            s_WB_RegWrite  <= i_MEM_RegWrite;  -- Register write control signal
            s_WB_jal       <= i_MEM_jal;       -- Jump and link write back control signal
            s_WB_PCP4      <= i_MEM_PCP4;      -- PC+4 value
            s_WB_RegWrAddr <= i_MEM_RegWrAddr; -- Write address
            s_WB_Dmem_Addr <= i_MEM_Dmem_Addr; -- Output from the ALU
        else
            s_WB_halt      <= s_WB_halt;      -- Halt control signal
            s_WB_MemToReg  <= s_WB_MemToReg;  -- MemToReg control signal
            s_WB_RegWrite  <= s_WB_RegWrite;  -- Register write control signal
            s_WB_jal       <= s_WB_jal;       -- Jump and link write back control signal
            s_WB_PCP4      <= s_WB_PCP4;      -- PC+4 value
            s_WB_RegWrAddr <= s_WB_RegWrAddr; -- Write address
            s_WB_Dmem_Addr <= s_WB_Dmem_Addr; -- Output from the ALU
        end if;

    end process;

end mixed;