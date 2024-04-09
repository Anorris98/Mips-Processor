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
        i_CLK : in std_logic; -- Clock input
        i_RST : in std_logic; -- Reset input
        i_ID_halt_c : in std_logic; -- Halt control signal
        i_ID_STD_Shift_c : in std_logic; -- STD Shift control signal
        i_ID_ALU_Src_c : in std_logic; -- ALU Source control signal
        i_ID_ALU_Control_c : in std_logic_vector(7 downto 0); -- ALU Control signals
        i_ID_MemToReg_c : in std_logic_vector(1 downto 0); -- MemToReg control signal
        i_ID_MemWrite_c : in std_logic; -- Memory write control signal
        i_ID_RegWrite_c : in std_logic; -- Register write control signal
        i_ID_RegDst_c : in std_logic_vector(1 downto 0); -- Register destination control signal
        i_ID_Jump_c : in std_logic; -- Jump control signal
        i_ID_ext_ctl : in std_logic; -- Sign extension control signal
        i_ID_jal_C : in std_logic; -- Jump and link write back control signal
        i_ID_jr_c : in std_logic; -- Jump return control signal
        i_ID_PCP4 : in std_logic_vector(31 downto 0); -- PC+4 value
        i_ID_instr20t16 : in std_logic_vector(4 downto 0); -- Register Rt address signal
        i_ID_instr15t11 : in std_logic_vector(4 downto 0); -- Register Rd address signal
        i_ID_rs_data_o : in std_logic_vector(31 downto 0); -- Output from Rs address
        i_ID_rt_data_o : in std_logic_vector(31 downto 0); -- Output from Rt address
        i_ID_ext_o : in std_logic_vector(31 downto 0); -- Extension control output
        i_ID_s120_o : in std_logic_vector(27 downto 0); -- Instruction [25:0] shifted left 2
        ------------------------------------------------------------------------------------
        -- outputs
        ------------------------------------------------------------------------------------
        o_EX_halt_c : out std_logic; -- Halt control signal
        o_EX_STD_Shift_c : out std_logic; -- STD Shift control signal
        o_EX_ALU_Src_c : out std_logic; -- ALU Source control signal
        o_EX_ALU_Control_c : out std_logic_vector(7 downto 0); -- ALU Control signals
        o_EX_MemToReg_c : out std_logic_vector(1 downto 0); -- MemToReg control signal
        o_EX_MemWrite_c : out std_logic; -- Memory write control signal
        o_EX_RegWrite_c : out std_logic; -- Register write control signal
        o_EX_RegDst_c : out std_logic_vector(1 downto 0); -- Register destination control signal
        o_EX_Jump_c : out std_logic; -- Jump control signal
        o_EX_ext_ctl : out std_logic; -- Sign extension control signal
        o_EX_jal_C : out std_logic; -- Jump and link write back control signal
        o_EX_jr_c : out std_logic; -- Jump return control signal
        o_EX_PCP4 : out std_logic_vector(31 downto 0); -- PC+4 value
        o_EX_instr20t16 : out std_logic_vector(4 downto 0); -- Register Rt address signal
        o_EX_instr15t11 : out std_logic_vector(4 downto 0); -- Register Rd address signal
        o_EX_rs_data_o : out std_logic_vector(31 downto 0); -- Output from Rs address
        o_EX_rt_data_o : out std_logic_vector(31 downto 0); -- Output from Rt address
        o_EX_ext_o : out std_logic_vector(31 downto 0); -- Extension control output
        o_EX_s120_o : out std_logic_vector(27 downto 0); -- Instruction [25:0] shifted left 2
    );

end ID_EX_pipe;

architecture mixed of ID_EX_pipe is
    signal s_ID_halt_c : std_logic; -- Halt control signal
    signal s_ID_STD_Shift_c : std_logic; -- STD Shift control signal
    signal s_ID_ALU_Src_c : std_logic; -- ALU Source control signal
    signal s_ID_ALU_Control_c : std_logic_vector(7 downto 0); -- ALU Control signals
    signal s_ID_MemToReg_c : std_logic_vector(1 downto 0); -- MemToReg control signal
    signal s_ID_MemWrite_c : std_logic; -- Memory write control signal
    signal s_ID_RegWrite_c : std_logic; -- Register write control signal
    signal s_ID_RegDst_c : std_logic_vector(1 downto 0); -- Register destination control signal
    signal s_ID_Jump_c : std_logic; -- Jump control signal
    signal s_ID_ext_ctl : std_logic; -- Sign extension control signal
    signal s_ID_jal_C : std_logic; -- Jump and link write back control signal
    signal s_ID_jr_c : std_logic; -- Jump return control signal
    signal s_ID_PCP4 : std_logic_vector(31 downto 0); -- PC+4 value
    signal s_ID_instr20t16 : std_logic_vector(4 downto 0); -- Register Rt address signal
    signal s_ID_instr15t11 : std_logic_vector(4 downto 0); -- Register Rd address signal
    signal s_ID_rs_data_o : std_logic_vector(31 downto 0); -- Output from Rs address
    signal s_ID_rt_data_o : std_logic_vector(31 downto 0); -- Output from Rt address
    signal s_ID_ext_o : std_logic_vector(31 downto 0); -- Extension control output
    signal s_ID_s120_o : std_logic_vector(27 downto 0); -- Instruction [25:0] shifted left 2

begin

    -- The output of the FF is fixed to s_Q
    o_EX_halt_c <= s_ID_halt_c; -- Halt control signal
    o_EX_STD_Shift_c <= s_ID_STD_Shift_c; -- STD Shift control signal
    o_EX_ALU_Src_c <= s_ID_ALU_Src_c; -- ALU Source control signal
    o_EX_ALU_Control_c <= s_ID_ALU_Control_c; -- ALU Control signals
    o_EX_MemToReg_c <= s_ID_MemToReg_c; -- MemToReg control signal
    o_EX_MemWrite_c <= s_ID_MemWrite_c; -- Memory write control signal
    o_EX_RegWrite_c <= s_ID_RegWrite_c; -- Register write control signal
    o_EX_RegDst_c <= s_ID_RegDst_c; -- Register destination control signal
    o_EX_Jump_c <= s_ID_Jump_c; -- Jump control signal
    o_EX_ext_ctl <= s_ID_ext_ctl; -- Sign extension control signal
    o_EX_jal_C <= s_ID_jal_C; -- Jump and link write back control signal
    o_EX_jr_c <= s_ID_jr_c; -- Jump return control signal
    o_EX_PCP4 <= s_ID_PCP4; -- PC+4 value
    o_EX_instr20t16 <= s_ID_instr20t16; -- Register Rt address signal
    o_EX_instr15t11 <= s_ID_instr15t11; -- Register Rd address signal
    o_EX_rs_data_o <= s_ID_rs_data_o; -- Output from Rs address
    o_EX_rt_data_o <= s_ID_rt_data_o; -- Output from Rt address
    o_EX_ext_o <= s_ID_ext_o; -- Extension control output
    o_EX_s120_o <= s_ID_s120_o; -- Instruction [25:0] shifted left 2

    -- This process handles the asyncrhonous reset and
    -- synchronous write. We want to be able to reset 
    -- our processor's registers so that we minimize
    -- glitchy behavior on startup.
    process (i_CLK, i_RST)
    begin
        if (i_RST = '1') then
            s_ID_halt_c <= '0'; -- Halt control signal
            s_ID_STD_Shift_c <= '0'; -- STD Shift control signal
            s_ID_ALU_Src_c <= '0'; -- ALU Source control signal
            s_ID_ALU_Control_c <= '00000000'; -- ALU Control signals
            s_ID_MemToReg_c <= '00'; -- MemToReg control signal
            s_ID_MemWrite_c <= '0'; -- Memory write control signal
            s_ID_RegWrite_c <= '0'; -- Register write control signal
            s_ID_RegDst_c <= '00'; -- Register destination control signal
            s_ID_Jump_c <= '0'; -- Jump control signal
            s_ID_ext_ctl <= '0'; -- Sign extension control signal
            s_ID_jal_C <= '0'; -- Jump and link write back control signal
            s_ID_jr_c <= '0'; -- Jump return control signal
            s_ID_PCP4 <= x"00400004"; -- PC+4 value
            s_ID_instr20t16 <= b'00000'; -- Register Rt address signal
            s_ID_instr15t11 <= b'00000'; -- Register Rd address signal
            s_ID_rs_data_o <= x"00000000"; -- Output from Rs address
            s_ID_rt_data_o <= x"00000000"; -- Output from Rt address
            s_ID_ext_o <= x"00000000"; -- Extension control output
            s_ID_s120_o <= x"0000000"; -- Instruction [25:0] shifted left 2
        elsif (rising_edge(i_CLK)) then
            s_ID_halt_c <= i_ID_halt_c; -- Halt control signal
            s_ID_STD_Shift_c <= i_ID_STD_Shift_c; -- STD Shift control signal
            s_ID_ALU_Src_c <= i_ID_ALU_Src_c; -- ALU Source control signal
            s_ID_ALU_Control_c <= i_ID_ALU_Control_c; -- ALU Control signals
            s_ID_MemToReg_c <= i_ID_MemToReg_c; -- MemToReg control signal
            s_ID_MemWrite_c <= i_ID_MemWrite_c; -- Memory write control signal
            s_ID_RegWrite_c <= i_ID_RegWrite_c; -- Register write control signal
            s_ID_RegDst_c <= i_ID_RegDst_c; -- Register destination control signal
            s_ID_Jump_c <= i_ID_Jump_c; -- Jump control signal
            s_ID_ext_ctl <= i_ID_ext_ctl; -- Sign extension control signal
            s_ID_jal_C <= i_ID_jal_C; -- Jump and link write back control signal
            s_ID_jr_c <= i_ID_jr_c; -- Jump return control signal
            s_ID_PCP4 <= i_ID_PCP4; -- PC+4 value
            s_ID_instr20t16 <= i_ID_instr20t16; -- Register Rt address signal
            s_ID_instr15t11 <= i_ID_instr15t11; -- Register Rd address signal
            s_ID_rs_data_o <= i_ID_rs_data_o; -- Output from Rs address
            s_ID_rt_data_o <= i_ID_rt_data_o; -- Output from Rt address
            s_ID_ext_o <= i_ID_ext_o; -- Extension control output
            s_ID_s120_o <= i_ID_s120_o; -- Instruction [25:0] shifted left 2
        end if;

    end process;

end mixed;