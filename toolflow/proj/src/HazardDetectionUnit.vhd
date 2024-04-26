-------------------------------------------------------------------------
-- Alek Norris
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity HazardDetectionUnit is
  port (
    i_ID_Reg_Rt : in std_logic_vector(4 downto 0); -- Register Rt in ID stage
    i_ID_Reg_Rs : in std_logic_vector(4 downto 0); -- Register Rs in ID stage

    i_EX_Reg_Dst  : in std_logic_vector(4 downto 0); -- Register destination in EX stage
    i_MEM_Reg_Dst : in std_logic_vector(4 downto 0); -- Register destination in MEM stage

    i_EX_We  : in std_logic; -- Write enable in EX stage
    i_MEM_We : in std_logic; -- Write enable in MEM stage

    o_Fwd_Mux0_Sel : out std_logic_vector(2 downto 0); -- Forwarding mux 1 control
    o_Fwd_Mux1_Sel : out std_logic_vector(2 downto 0); -- Forwarding mux 2 control
    o_Stall_IFID   : out std_logic;                    -- Signal to Stall IFID Pipeline Register, will also stall PC.
    o_Stall_IDEX   : out std_logic;                    -- Signal to Stall IDEX Pipeline Register
    o_Stall_EXMEM  : out std_logic;                    -- Signal to Stall EXMEM Pipeline Register
    o_Stall_MEMWB  : out std_logic                     -- Signal to Stall MEMWB Pipeline Register
  );
end entity;

architecture mixed of HazardDetectionUnit is

begin
  o_Stall_IDEX   <= '0';   -- Never stall the IDEX pipe
  o_Stall_EXMEM  <= '0';   -- Never stall the EXMEM pipe
  o_Stall_MEMWB  <= '0';   -- Never stall the MEMWB pipe
  o_Fwd_Mux0_Sel <= "000"; -- No Forwarding yet
  o_Fwd_Mux1_Sel <= "000"; -- No Forwarding yet

  o_Stall_IFID <= '1' when ((i_EX_Reg_Dst /= "00000" and (i_EX_We = '1' and i_EX_Reg_Dst = i_ID_Reg_Rt))
                        or (i_EX_Reg_Dst /= "00000" and (i_EX_We = '1' and i_EX_Reg_Dst = i_ID_Reg_Rs))) else
                  '1' when ((i_MEM_Reg_Dst /= "00000" and (i_MEM_We = '1' and i_MEM_Reg_Dst = i_ID_Reg_Rt)) 
                        or (i_MEM_Reg_Dst /= "00000"and (i_MEM_We = '1' and i_MEM_Reg_Dst = i_ID_Reg_Rs))) else
                  '0';

                  
end architecture;