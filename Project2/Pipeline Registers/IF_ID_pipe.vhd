-------------------------------------------------------------------------
-- Drew Kearns
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- IF_ID_pipe.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity IF_ID_pipe is
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

end IF_ID_pipe;

architecture mixed of IF_ID_pipe is
    -- s_D
    signal s_IF_PC_P4     : std_logic_vector(N - 1 downto 0); -- Output of the FF
    signal s_IF_instr31t0 : std_logic_vector(N - 1 downto 0); -- Output of the FF
    -- s_Q
    signal s_ID_PC_P4     : std_logic_vector(N - 1 downto 0); -- Output of the FF
    signal s_ID_instr31t0 : std_logic_vector(N - 1 downto 0); -- Output of the FF

begin

    -- The output of the FF is fixed to s_Q
    -- o_Q <= s_Q
    o_ID_PC_P4     <= s_ID_PC_P4;
    o_ID_instr31t0 <= s_ID_instr31t0;

    -- This process handles the asyncrhonous reset and
    -- synchronous write. We want to be able to reset 
    -- our processor's registers so that we minimize
    -- glitchy behavior on startup.
    -- if (rising_edge(i_CLK) and i_WE = '0') then
    process (i_CLK, i_RST, i_WE)
    begin
        if (i_RST = '1' or (rising_edge(i_CLK) and i_FLUSH = '1')) then
            s_ID_PC_P4     <= x"00000000"; -- Use "(others => '0')" for N-bit values
            s_ID_instr31t0 <= x"00000000";
        elsif (rising_edge(i_CLK) and i_WE = '1') then
            s_ID_PC_P4     <= i_IF_PC_P4;
            s_ID_instr31t0 <= i_IF_instr31t0;
        else
            s_ID_PC_P4     <= s_ID_PC_P4;
            s_ID_instr31t0 <= s_ID_instr31t0;
        end if;

    end process;

end mixed;