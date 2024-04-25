-------------------------------------------------------------------------
-- Alek Norris
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity HazardDetectionUnit is
  port (
    i_EX_Reg_Rt : in std_logic_vector(4 downto 0); -- Register Rt in EX stage
    i_EX_Reg_Rs : in std_logic_vector(4 downto 0); -- Register Rs in EX stage
    i_ID_Reg_Rt : in std_logic_vector(4 downto 0); -- Register Rt in ID stage
    i_ID_Reg_Rs : in std_logic_vector(4 downto 0); -- Register Rs in ID stage

    i_EX_opcode  : in std_logic_vector(5 downto 0); -- Opcode in EX stage
    i_MEM_opcode : in std_logic_vector(5 downto 0); -- Opcode in MEM stage

    i_MEM_Reg_Dst : in std_logic_vector(4 downto 0); -- Register destination in MEM stage
    i_WB_Reg_Dst  : in std_logic_vector(4 downto 0); -- Register destination in WB stage

    i_WB_We        : in std_logic;                     -- Write enable in ID stage
    o_Fwd_Mux0_Sel : out std_logic_vector(2 downto 0); -- Forwarding mux 1 control
    o_Fwd_Mux1_Sel : out std_logic_vector(2 downto 0); -- Forwarding mux 2 control
    o_Stall_IFID   : out std_logic;                    -- Signal to Stall IFID Pipeline Register, will also stall PC.
    o_Stall_IDEX   : out std_logic;                    -- Signal to Stall IDEX Pipeline Register
    o_Stall_EXMEM  : out std_logic;                    -- Signal to Stall EXMEM Pipeline Register
    o_Stall_MEMWB  : out std_logic                     -- Signal to Stall MEMWB Pipeline Register
  );
end entity;

architecture mixed of HazardDetectionUnit is

  -- signal rsForwarded : std_logic := '0';
  -- signal rtForwarded : std_logic := '0';

begin
  o_Stall_MEMWB <= '0'; -- Never stall the MEMWB pipe
  o_Fwd_Mux0_Sel <= "000"; -- No Forwarding yet
  o_Fwd_Mux1_Sel <= "000"; -- No Forwarding yet

  o_Stall_IFID <= '1' when (i_MEM_Reg_Dst /= "00000" and (i_WB_We = '1' and i_MEM_Reg_Dst = i_ID_Reg_Rt)
                        or (i_WB_We = '1' and i_MEM_Reg_Dst = i_ID_Reg_Rs)) else
                  '1' when (i_WB_Reg_Dst /= "00000" and (i_WB_We = '1' and i_WB_Reg_Dst = i_ID_Reg_Rt)
                        or (i_WB_We = '1' and i_WB_Reg_Dst = i_ID_Reg_Rs)) else
                  '0';

  o_Stall_IDEX <= '1' when (i_MEM_Reg_Dst /= "00000" and (i_WB_We = '1' and i_MEM_Reg_Dst = i_ID_Reg_Rt)
                        or (i_WB_We = '1' and i_MEM_Reg_Dst = i_ID_Reg_Rs)) else
                  '1' when (i_WB_Reg_Dst /= "00000" and (i_WB_We = '1' and i_WB_Reg_Dst = i_ID_Reg_Rt)
                        or (i_WB_We = '1' and i_WB_Reg_Dst = i_ID_Reg_Rs)) else
                  '0';

  -- o_Stall_EXMEM               ??????
end architecture;