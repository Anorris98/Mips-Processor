-------------------------------------------------------------------------
-- Drew Kearns
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- EX_MEM_pipe.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity EX_MEM_pipe is
    generic (N : integer := 32);
    port (
        i_CLK           : in std_logic;                     -- Clock input
        i_RST           : in std_logic;                     -- Reset input
        i_WE            : in std_logic;                     -- Write enable
        i_EX_halt_c     : in std_logic;                     -- Halt control signal
        i_EX_MemToReg_c : in std_logic_vector(1 downto 0);  -- MemToReg control signal
        i_EX_MemWrite_c : in std_logic;                     -- Memory write control signal
        i_EX_RegWrite_c : in std_logic;                     -- Register write control signal
        i_EX_Jump_c     : in std_logic;                     -- Jump control signal
        i_EX_ext_ctl    : in std_logic;                     -- Sign extension control signal
        i_EX_jal_C      : in std_logic;                     -- Jump and link write back control signal
        i_EX_jr_c       : in std_logic;                     -- Jump return control signal
        i_EX_branch     : in std_logic;                     -- Branch output from ALU
        i_EX_PCP4       : in std_logic_vector(31 downto 0); -- PC+4 value
        i_EX_rs_data_o  : in std_logic_vector(31 downto 0); -- Output from Rs address
        i_EX_rt_data_o  : in std_logic_vector(31 downto 0); -- Output from Rt address
        i_EX_pc4_s120_o : in std_logic_vector(31 downto 0); -- Jump address
        i_EX_RegWrAddr  : in std_logic_vector(4 downto 0);  -- Write address
        i_EX_Dmem_Addr  : in std_logic_vector(31 downto 0); -- Output from the ALU
        i_EX_add1_mux2  : in std_logic_vector(31 downto 0); -- Output from Adder 1
        ------------------------------------------------------------------------------------
        -- outputs
        ------------------------------------------------------------------------------------
        o_MEM_halt_c     : out std_logic;                     -- Halt control signal
        o_MEM_MemToReg_c : out std_logic_vector(1 downto 0);  -- MemToReg control signal
        o_MEM_MemWrite_c : out std_logic;                     -- Memory write control signal
        o_MEM_RegWrite_c : out std_logic;                     -- Register write control signal
        o_MEM_Jump_c     : out std_logic;                     -- Jump control signal
        o_MEM_ext_ctl    : out std_logic;                     -- Sign extension control signal
        o_MEM_jal_C      : out std_logic;                     -- Jump and link write back control signal
        o_MEM_jr_c       : out std_logic;                     -- Jump return control signal
        o_MEM_branch     : out std_logic;                     -- Branch output from ALU
        o_MEM_PCP4       : out std_logic_vector(31 downto 0); -- PC+4 value
        o_MEM_rs_data_o  : out std_logic_vector(31 downto 0); -- Output from Rs address
        o_MEM_rt_data_o  : out std_logic_vector(31 downto 0); -- Output from Rt address
        o_MEM_pc4_s120_o : out std_logic_vector(31 downto 0); -- Jump address
        o_MEM_RegWrAddr  : out std_logic_vector(4 downto 0);  -- Write address
        o_MEM_Dmem_Addr  : out std_logic_vector(31 downto 0); -- Output from the ALU
        o_MEM_add1_mux2  : out std_logic_vector(31 downto 0)  -- Output from Adder 1
    );

end EX_MEM_pipe;

architecture mixed of EX_MEM_pipe is
    -- s_D
    signal s_EX_halt_c     : std_logic;                     -- Halt control signal
    signal s_EX_MemToReg_c : std_logic_vector(1 downto 0);  -- MemToReg control signal
    signal s_EX_MemWrite_c : std_logic;                     -- Memory write control signal
    signal s_EX_RegWrite_c : std_logic;                     -- Register write control signal
    signal s_EX_Jump_c     : std_logic;                     -- Jump control signal
    signal s_EX_ext_ctl    : std_logic;                     -- Sign extension control signal
    signal s_EX_jal_C      : std_logic;                     -- Jump and link write back control signal
    signal s_EX_jr_c       : std_logic;                     -- Jump return control signal
    signal s_EX_branch     : std_logic;                     -- Branch output from ALU
    signal s_EX_PCP4       : std_logic_vector(31 downto 0); -- PC+4 value
    signal s_EX_rs_data_o  : std_logic_vector(31 downto 0); -- Output from Rs address
    signal s_EX_rt_data_o  : std_logic_vector(31 downto 0); -- Output from Rt address
    signal s_EX_pc4_s120_o : std_logic_vector(31 downto 0); -- Jump address
    signal s_EX_RegWrAddr  : std_logic_vector(4 downto 0);  -- Write address
    signal s_EX_Dmem_Addr  : std_logic_vector(31 downto 0); -- Output from the ALU
    signal s_EX_add1_mux2  : std_logic_vector(31 downto 0); -- Output from Adder 1
    -- s_Q
    signal s_MEM_halt_c     : std_logic;                     -- Halt control signal
    signal s_MEM_MemToReg_c : std_logic_vector(1 downto 0);  -- MemToReg control signal
    signal s_MEM_MemWrite_c : std_logic;                     -- Memory write control signal
    signal s_MEM_RegWrite_c : std_logic;                     -- Register write control signal
    signal s_MEM_Jump_c     : std_logic;                     -- Jump control signal
    signal s_MEM_ext_ctl    : std_logic;                     -- Sign extension control signal
    signal s_MEM_jal_C      : std_logic;                     -- Jump and link write back control signal
    signal s_MEM_jr_c       : std_logic;                     -- Jump return control signal
    signal s_MEM_branch     : std_logic;                     -- Branch output from ALU
    signal s_MEM_PCP4       : std_logic_vector(31 downto 0); -- PC+4 value
    signal s_MEM_rs_data_o  : std_logic_vector(31 downto 0); -- Output from Rs address
    signal s_MEM_rt_data_o  : std_logic_vector(31 downto 0); -- Output from Rt address
    signal s_MEM_pc4_s120_o : std_logic_vector(31 downto 0); -- Jump address
    signal s_MEM_RegWrAddr  : std_logic_vector(4 downto 0);  -- Write address
    signal s_MEM_Dmem_Addr  : std_logic_vector(31 downto 0); -- Output from the ALU
    signal s_MEM_add1_mux2  : std_logic_vector(31 downto 0); -- Output from Adder 1

begin

    -- The output of the FF is fixed to s_Q
    -- o_Q <= s_Q
    o_MEM_halt_c     <= s_MEM_halt_c;     -- Halt control signal
    o_MEM_MemToReg_c <= s_MEM_MemToReg_c; -- MemToReg control signal
    o_MEM_MemWrite_c <= s_MEM_MemWrite_c; -- Memory write control signal
    o_MEM_RegWrite_c <= s_MEM_RegWrite_c; -- Register write control signal
    o_MEM_Jump_c     <= s_MEM_Jump_c;     -- Jump control signal
    o_MEM_ext_ctl    <= s_MEM_ext_ctl;    -- Sign extension control signal
    o_MEM_jal_C      <= s_MEM_jal_C;      -- Jump and link write back control signal
    o_MEM_jr_c       <= s_MEM_jr_c;       -- Jump return control signal
    o_MEM_branch     <= s_MEM_branch;     -- Branch output from ALU
    o_MEM_PCP4       <= s_MEM_PCP4;       -- PC+4 value
    o_MEM_rs_data_o  <= s_MEM_rs_data_o;  -- Output from Rs address
    o_MEM_rt_data_o  <= s_MEM_rt_data_o;  -- Output from Rt address
    o_MEM_pc4_s120_o <= s_MEM_pc4_s120_o; -- Jump address
    o_MEM_RegWrAddr  <= s_MEM_RegWrAddr;  -- Write address
    o_MEM_Dmem_Addr  <= s_MEM_Dmem_Addr;  -- Output from the ALU
    o_MEM_add1_mux2  <= s_MEM_add1_mux2;  -- Output from Adder 1

    -- This process handles the asyncrhonous reset and
    -- synchronous write. We want to be able to reset 
    -- our processor's registers so that we minimize
    -- glitchy behavior on startup.
    process (i_CLK, i_RST, i_WE)
    begin
        if (i_RST = '1') then
            s_MEM_halt_c     <= '0';         -- Halt control signal
            s_MEM_MemToReg_c <= b"00";       -- MemToReg control signal
            s_MEM_MemWrite_c <= '0';         -- Memory write control signal
            s_MEM_RegWrite_c <= '0';         -- Register write control signal
            s_MEM_Jump_c     <= '0';         -- Jump control signal
            s_MEM_ext_ctl    <= '0';         -- Sign extension control signal
            s_MEM_jal_C      <= '0';         -- Jump and link write back control signal
            s_MEM_jr_c       <= '0';         -- Jump return control signal
            s_MEM_branch     <= '0';         -- Branch output from ALU
            s_MEM_PCP4       <= x"00400000"; -- PC+4 value
            s_MEM_rs_data_o  <= x"00000000"; -- Output from Rs address
            s_MEM_rt_data_o  <= x"00000000"; -- Output from Rt address
            s_MEM_pc4_s120_o <= x"00000000"; -- Jump address
            s_MEM_RegWrAddr  <= b"00000";    -- Write address
            s_MEM_Dmem_Addr  <= x"00000000"; -- Output from the ALU
            s_MEM_add1_mux2  <= x"00000000"; -- Output from Adder 1
        elsif (rising_edge(i_CLK) and i_WE = '1') then
            s_MEM_halt_c     <= i_EX_halt_c;     -- Halt control signal
            s_MEM_MemToReg_c <= i_EX_MemToReg_c; -- MemToReg control signal
            s_MEM_MemWrite_c <= i_EX_MemWrite_c; -- Memory write control signal
            s_MEM_RegWrite_c <= i_EX_RegWrite_c; -- Register write control signal
            s_MEM_Jump_c     <= i_EX_Jump_c;     -- Jump control signal
            s_MEM_ext_ctl    <= i_EX_ext_ctl;    -- Sign extension control signal
            s_MEM_jal_C      <= i_EX_jal_C;      -- Jump and link write back control signal
            s_MEM_jr_c       <= i_EX_jr_c;       -- Jump return control signal
            s_MEM_branch     <= i_EX_branch;     -- Branch output from ALU
            s_MEM_PCP4       <= i_EX_PCP4;       -- PC+4 value
            s_MEM_rs_data_o  <= i_EX_rs_data_o;  -- Output from Rs address
            s_MEM_rt_data_o  <= i_EX_rt_data_o;  -- Output from Rt address
            s_MEM_pc4_s120_o <= i_EX_pc4_s120_o; -- Jump address
            s_MEM_RegWrAddr  <= i_EX_RegWrAddr;  -- Write address
            s_MEM_Dmem_Addr  <= i_EX_Dmem_Addr;  -- Output from the ALU
            s_MEM_add1_mux2  <= i_EX_add1_mux2;  -- Output from Adder 1
        else
            s_MEM_halt_c     <= s_MEM_halt_c;     -- Halt control signal
            s_MEM_MemToReg_c <= s_MEM_MemToReg_c; -- MemToReg control signal
            s_MEM_MemWrite_c <= s_MEM_MemWrite_c; -- Memory write control signal
            s_MEM_RegWrite_c <= s_MEM_RegWrite_c; -- Register write control signal
            s_MEM_Jump_c     <= s_MEM_Jump_c;     -- Jump control signal
            s_MEM_ext_ctl    <= s_MEM_ext_ctl;    -- Sign extension control signal
            s_MEM_jal_C      <= s_MEM_jal_C;      -- Jump and link write back control signal
            s_MEM_jr_c       <= s_MEM_jr_c;       -- Jump return control signal
            s_MEM_branch     <= s_MEM_branch;     -- Branch output from ALU
            s_MEM_PCP4       <= s_MEM_PCP4;       -- PC+4 value
            s_MEM_rs_data_o  <= s_MEM_rs_data_o;  -- Output from Rs address
            s_MEM_rt_data_o  <= s_MEM_rt_data_o;  -- Output from Rt address
            s_MEM_pc4_s120_o <= s_MEM_pc4_s120_o; -- Jump address
            s_MEM_RegWrAddr  <= s_MEM_RegWrAddr;  -- Write address
            s_MEM_Dmem_Addr  <= s_MEM_Dmem_Addr;  -- Output from the ALU
            s_MEM_add1_mux2  <= s_MEM_add1_mux2;  -- Output from Adder 1
        end if;

    end process;

end mixed;