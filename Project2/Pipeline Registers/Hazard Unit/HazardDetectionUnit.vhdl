-------------------------------------------------------------------------
-- Alek Norris
-------------------------------------------------------------------------
library IEEE;
  use IEEE.std_logic_1164.all;

entity HazardDetectionUnit is
  port (i_EX_Reg_Rt    : in  std_logic_vector(4 downto 0);  -- Register Rt in EX stage
        i_EX_Reg_Rs    : in  std_logic_vector(4 downto 0);  -- Register Rs in EX stage
        i_MEM_Reg_Dst  : in  std_logic_vector(4 downto 0);  -- Register destination in MEM stage
        i_WB_Reg_Dst   : in  std_logic_vector(4 downto 0);  -- Register destination in WB stage
        i_PC_Addr      : in  std_logic_vector(31 downto 0); -- PC address, used for sensativity list.
        i_MEM_opcode   : in  std_logic_vector(5 downto 0);  -- Opcode in MEM stage
        i_ID_Rt        : in  std_logic_vector(4 downto 0);  -- Register Rt in ID stage
        i_ID_Rs        : in  std_logic_vector(4 downto 0);  -- Register Rs in ID stage
        i_WB_We        : in  std_logic;                     -- Write enable in ID stage
        o_Fwd_Mux0_Sel : out std_logic_vector(2 downto 0);  -- Forwarding mux 1 control
        o_Fwd_Mux1_Sel : out std_logic_vector(2 downto 0);  -- Forwarding mux 2 control
        o_Stall_IFID   : out std_logic;                     -- Signal to Stall IFID Pipeline Register, will also stall PC.
        o_Stall_IDEX   : out std_logic;                     -- Signal to Stall IDEX Pipeline Register
        o_Stall_EXMEM  : out std_logic;                     -- Signal to Stall EXMEM Pipeline Register
        o_Stall_MEMWB  : out std_logic                      -- Signal to Stall MEMWB Pipeline Register
       );
end entity;

architecture sel_when of HazardDetectionUnit is

signal rsForwarded : std_logic := '0';
signal rtForwarded : std_logic := '0';

begin
  process (i_MEM_Reg_Dst, i_WB_Reg_Dst, i_EX_Reg_Rt, i_EX_Reg_Rs, i_PC_Addr, i_MEM_opcode)
  begin
    -- Initialize forward signals and stall signals to default 'no hazard' state
    rsForwarded <='0';
    rtForwarded <='0';
    o_Fwd_Mux0_Sel <= "000";
    o_Fwd_Mux1_Sel <= "000";
    o_Stall_IFID <= '0';
    o_Stall_IDEX <= '0';
    o_Stall_EXMEM <= '0';
    o_Stall_MEMWB <= '0';

    -- This stage works by cascading through the stages, first by checking the RS and RT for Matches in the MEM stage, then 
    -- checking for matchs for Rs and Rt in the WB Stage, 

    -- checks for rs and rt match in the mem stage, and sets a flag for which one they matched, to not attempt matching a later wb match.
    if ((i_EX_Reg_Rs = i_MEM_Reg_Dst) or (i_EX_Reg_Rt = i_MEM_Reg_Dst)) then --remember to check for lw and sw.

      if (i_EX_Reg_Rt = i_MEM_Reg_Dst) then -- Arithmatic & logic MEM #2
        o_Fwd_Mux1_Sel <= "101"; -- E
        rtForwarded <= '1';
      end if;

      if(i_EX_Reg_Rs = i_MEM_Reg_Dst) then
        rsForwarded <= '1';

        elsif(i_MEM_opcode = "100011") then --Lw MEM done
          o_Fwd_Mux0_Sel <= "001"; -- A

        elsif((i_MEM_opcode = "100000") or (i_MEM_opcode = "100100")) then --Lb, lbu MEM done
          o_Fwd_Mux0_Sel <= "011"; -- C

        elsif((i_MEM_opcode = "100001") or (i_MEM_opcode = "100101")) then --LH, LHU MEM done
          o_Fwd_Mux0_Sel <= "010";  -- B

        else    -- Arithmatic & logic MEM #1
          o_Fwd_Mux0_Sel <= "101"; -- E

      end if;
    end if;

  -- Data hazard detection For RS in WB or RT in WB
    if(((i_EX_Reg_Rs = i_WB_Reg_Dst) and (rsForwarded = '0')) or ((i_EX_Reg_Rt = i_WB_Reg_Dst) and (rtForwarded = '0'))) then
      
      if (((i_EX_Reg_Rs = i_WB_Reg_Dst) and (rsForwarded = '0'))) then -- Arithmatic & logic MEM #3 and LW, LB, LBU, LH, and LHU WB.
        o_Fwd_Mux0_Sel <= "100"; -- D
        rsForwarded <= '1';

      else -- Arithmatic & logic MEM #4
        o_Fwd_Mux1_Sel <= "100"; -- D
        rtForwarded <= '1';
        end if;
    end if;

    if((i_WB_We = '1') and ((i_ID_Rt = i_MEM_Reg_Dst) or  i_ID_rs = i_WB_Reg_Dst)) then -- we need to stall if we are using data in WB stage in the ID stage.
      o_Stall_IFID <= '1';
      o_Stall_IDEX <= '1';

    end if;

    end process;
  end architecture;
