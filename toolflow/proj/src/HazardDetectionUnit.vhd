-------------------------------------------------------------------------
-- Alek Norris
-------------------------------------------------------------------------
library IEEE;
  use IEEE.std_logic_1164.all;

entity HazardDetectionUnit is
  port (
    i_ID_Reg_Rt    : in  std_logic_vector(4 downto 0);          -- Register Rt in ID stage
    i_ID_Reg_Rs    : in  std_logic_vector(4 downto 0);          -- Register Rs in ID stage

    i_EX_ALU_Src   : in  std_logic;                             -- ALU control in EX stage
    i_EX_Reg_Rt    : in  std_logic_vector(4 downto 0);          -- Register Rt in EX stage
    i_EX_Reg_Rs    : in  std_logic_vector(4 downto 0);          -- Register Rs in EX stage
    i_EX_opcode    : in  std_logic_vector(5 downto 0);          -- Opcode in EX stage
    i_EX_Reg_Dst   : in  std_logic_vector(4 downto 0);          -- Register destination in EX stage
    i_EX_We        : in  std_logic;                             -- Write enable in EX stage

    i_MEM_Func     : in  std_logic_vector(5 downto 0);          -- Function in MEM stage
    i_MEM_opcode   : in  std_logic_vector(5 downto 0);          -- Opcode in MEM stage
    i_MEM_Reg_Dst  : in  std_logic_vector(4 downto 0);          -- Register destination in MEM stage
    i_MEM_We       : in  std_logic;                             -- Write enable in MEM stage

    i_WB_we        : in  std_logic;                             -- Write enable in WB stage
    i_WB_Reg_Dst   : in  std_logic_vector(4 downto 0);          -- Register destination in WB stage

    o_Fwd_Mux0_Sel : out std_logic_vector(2 downto 0) := "000"; -- Forwarding mux 1 control
    o_Fwd_Mux1_Sel : out std_logic_vector(2 downto 0) := "000"; -- Forwarding mux 2 control
    o_Fwd_Mux2_Sel : out std_logic_vector(2 downto 0) := "000"; -- Forwarding mux 3 control (for sw instruction only.)

    o_Stall_IFID   : out std_logic;                             -- Signal to Stall IFID Pipeline Register, will also stall PC.
    o_Stall_IDEX   : out std_logic;                             -- Signal to Stall IDEX Pipeline Register
    o_Stall_EXMEM  : out std_logic;                             -- Signal to Stall EXMEM Pipeline Register
    o_Stall_MEMWB  : out std_logic;                              -- Signal to Stall MEMWB Pipeline Register
    o_Stall_PC     : out std_logic                              -- Signal to Stall PC
  );
end entity;

architecture mixed of HazardDetectionUnit is

begin

  o_Stall_IDEX  <= '0'; -- Never stall the IDEX pipe
  o_Stall_EXMEM <= '0'; -- Never stall the EXMEM pipe
  o_Stall_MEMWB <= '0'; -- Never stall the MEMWB pipe

  -------------------------------------------------------------------------
  -- Stall Section
  -------------------------------------------------------------------------
  o_Stall_IFID <= '1' when ((i_MEM_Reg_Dst /= "00000" and (i_MEM_We = '1' and i_MEM_Reg_Dst = i_ID_Reg_Rt)) 
                             or (i_MEM_Reg_Dst /= "00000" and (i_MEM_We = '1' and i_MEM_Reg_Dst = i_ID_Reg_Rs))) --else
                             or (i_EX_Reg_Dst /= "00000" and (i_EX_We = '1' and i_EX_Reg_Dst = i_ID_Reg_Rs)) else --for jr. small issue with jr if this isnt here.
                  '0';      

                  --Just something weird with the PC for the commented jr line.
                  -- then for the line above it, theres something weird with the 100 fwds, If you uncomment the --100's and the jr line above i think itll lead us to whatever is fwding wrong. Because only grendle or things that use JR fail
                      -- when the "100" is commented out and the jr line is uncommented.

                      --grendle --always fails
                      --jr only fails when "100" is commented out and the JR stall line is uncommented.
                      -- if 100 is commented and the jr line uncommented, only grendle will fail.
                      
  -------------------------------------------------------------------------
  -- Forwarding Unit Section
  -------------------------------------------------------------------------
  o_fwd_mux0_sel <= "000" when (i_EX_Reg_Dst = "00000") or (i_MEM_Reg_Dst = "00000" and i_WB_Reg_Dst = "00000") else                                   --No forwarding if we are about to write to reg 0.
                    "001" when ((i_EX_Reg_Rs = i_MEM_Reg_Dst) and (i_MEM_WE = '1') and (i_MEM_opcode = "100011")) else                                 --lw MEM, A
                    "011" when ((i_EX_Reg_Rs = i_MEM_Reg_Dst) and (i_MEM_WE = '1') and ((i_MEM_opcode = "100000") or (i_MEM_opcode = "100100"))) else  --Lb, lbu MEM, C
                    "010" when ((i_EX_Reg_Rs = i_MEM_Reg_Dst) and (i_MEM_WE = '1') and ((i_MEM_opcode = "100001")                                      --LH, LHU MEM, B
                                or (i_MEM_opcode = "100101"))) else
                    "101" when ((((i_EX_Reg_Rs = i_MEM_Reg_Dst) and (i_MEM_WE = '1')) and (i_MEM_Reg_Dst /= "00000"))) 
                                and ((i_MEM_opcode = "001111") or ((i_MEM_opcode = "001111" or i_EX_ALU_Src = '1')) or i_MEM_opcode /= "00000") else --Arithmatic & logic MEM #1, E, --also handles lui if rs is the same as the destination, but if not we dont want to fwd.
                    --  "100" when (((i_EX_Reg_Rs = i_WB_Reg_Dst and i_WB_WE = '1' and  i_EX_ALU_Src = '1'))) else --WB
                    "000"; --No forwarding

  o_Fwd_Mux1_Sel <= "000" when (i_EX_Reg_Dst = "00000") or (i_MEM_Reg_Dst = "00000" and i_WB_Reg_Dst = "00000") else                                  --No forwarding if we are about to write to reg 0.
                    -- "001" when ((i_EX_Reg_Rs = i_MEM_Reg_Dst) and (i_MEM_WE = '1') and (i_Mem_opcode /= "001111")) else --not lui, messes up because of zero reg. 
                    "001" when ((i_EX_Reg_Rt = i_MEM_Reg_Dst) and (i_MEM_WE = '1') and (i_Mem_opcode = "100011") and (i_EX_opcode /= "101011")) else                                --catches the lw.
                    "010" when ((i_EX_Reg_Rt = i_MEM_Reg_Dst) and (i_MEM_WE = '1') and ((i_MEM_opcode = "100001")                                     --LH, LHU MEM, B
                                or (i_MEM_opcode = "100101")) and (i_EX_opcode /= "101011")) else
                    "011" when ((i_EX_Reg_Rt = i_MEM_Reg_Dst) and (i_MEM_WE = '1') and ((i_MEM_opcode = "100000") or (i_MEM_opcode = "100100")) and (i_EX_opcode /= "101011")) else --Lb, lbu MEM, C
                    "101" when (((i_EX_Reg_Rt = i_MEM_Reg_Dst and i_MEM_WE = '1') and (i_MEM_Reg_Dst /= "00000")) and (i_EX_ALU_Src /= '1')) else     --Arithmatic & logic MEM #1, E, needs to checks the SRC because of the difference with IMM values, we use rt as the destination and not the source.
                    --  "100" when ((i_EX_Reg_Rt = i_WB_Reg_Dst and i_WB_WE = '1')) and (i_EX_ALU_Src /= '1') else --WB
                    "000"; --No forwarding

  o_Fwd_Mux2_Sel <= "000" when (i_EX_opcode = "101011") and ((i_EX_Reg_Dst = "00000") or (i_MEM_Reg_Dst = "00000")) else                                                            --No forwarding if we are about to write to reg 0.
                    "001" when (i_EX_opcode = "101011") and ((i_EX_Reg_Rt = i_MEM_Reg_Dst) and (i_MEM_WE = '1') and (i_MEM_opcode = "100011")) else                                 --lw MEM, A
                    "011" when (i_EX_opcode = "101011") and ((i_EX_Reg_Rt = i_MEM_Reg_Dst) and (i_MEM_WE = '1') and ((i_MEM_opcode = "100000") or (i_MEM_opcode = "100100"))) else  --Lb, lbu MEM, C
                    "010" when (i_EX_opcode = "101011") and ((i_EX_Reg_Rt = i_MEM_Reg_Dst) and (i_MEM_WE = '1') and ((i_MEM_opcode = "100001")                                      --LH, LHU MEM, B
                                or (i_MEM_opcode = "100101"))) else
                    "101" when (i_EX_opcode = "101011") and (((((i_EX_Reg_Rt = i_MEM_Reg_Dst) and (i_MEM_WE = '1')) and (i_MEM_Reg_Dst /= "00000"))) 
                                and ((i_MEM_opcode = "001111") or ((i_MEM_opcode = "001111" or i_EX_ALU_Src = '1')) or i_MEM_opcode /= "00000")) else --Arithmatic & logic MEM #1, E, --also handles lui if rs is the same as the destination, but if not we dont want to fwd.
                    -- "100" when ((i_EX_opcode = "101011") and ((i_EX_Reg_Rt = i_WB_Reg_Dst and i_WB_WE = '1'))) else --WB
                    "000"; --No forwarding

end architecture;
