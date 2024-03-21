-------------------------------------------------------------------------
-- Alek Norris
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- implimentaition of controlDecoderLogic, Important to note, if input for 31-26 is zero then we
-- use I type or J type, if not then we use R type, which is checked in this code.
--------------------------------------------------------------------------
library IEEE;
  use IEEE.std_logic_1164.all;

entity ControlDecoderLogic is
  port (
    i_instruct31_26 : in  std_logic_vector(5 downto 0); -- Instruction bits 31-26
    i_instruct5_0   : in  std_logic_vector(5 downto 0); -- Instruction bits 5-0
    o_Output        : out std_logic_vector(17 downto 0)
  );
end entity;

architecture sel_when of ControlDecoderLogic is

  --  output bits are as follows:
  --   w_Alu_Src     <= DecoderOutput(16);
  --   w_ALU_Ctl     <= DecoderOutput(15 downto 11);
  --   w_MemtoReg    <= DecoderOutput(10);
  --   w_MemWrite    <= DecoderOutput(9);
  --   w_RegWrite    <= DecoderOutput(8);
  --   w_RegDst      <= DecoderOutput(7 downto 6);
  --   w_Jump        <= DecoderOutput(5);
  --   w_Branch      <= DecoderOutput(4);
  --   w_MemRead     <= DecoderOutput(3);
  --   w_ext_ctl     <= DecoderOutput(2);
  --   w_jal         <= DecoderOutput(1);
  --   w_jr          <= DecoderOutput(0);

begin
  op: process (i_instruct31_26, i_instruct5_0) --I Or J Type
  begin

    if i_instruct31_26 = "000000" then
      -- i_instruct31_26 are all zeros, select based on i_instruct5_0
      case i_instruct5_0 is --I and J type
        when "001000" => -- addi
          o_Output <= "010100000010000100";
        when "001001" => -- addiu
          o_Output <= "010000000010000100"; -- need to implement no overflow detection for this one.
        when "001100" => -- andi
          o_Output <= "010100110010000100";
        when "001111" => -- lui
          o_Output <= "010001110010000100";
        when "100011" => -- lw
          o_Output <= "010100001010000000"; 
        when "001110" => -- xori
          o_Output <= "010101010010000100";
        when "001101" => -- ori
          o_Output <= "010101000010000100";
        when "001010" => -- slti
          o_Output <= "011110000010000100"; -- Verify this output
        when "101011" => -- sw
          o_Output <= "010100000100000000";
        when "000100" => -- beq
          o_Output <= "010110000000001100";
        when "000101" => -- bne
          o_Output <= "010110000000001100";
        when "100000" => -- lb
          o_Output <= "010100001010000000";
        when "100001" => -- lh
          o_Output <= "010100001010000000";
        when "100100" => -- lbu
          o_Output <= "010000001010000000";
        when "100101" => -- lhu
          o_Output <= "010000001010000000";
        when others =>
          o_Output <= (others => '0');  --default case
      end case;

    else
      -- i_instruct31_26 are not all zeros, select based on i_instruct31_26 R type
      case i_instruct31_26 is
        when "100000" => -- add
          o_Output <= "000100000010100000";
        when "100001" => -- addu
          o_Output <= "000000000010100000";
        when "100100" => -- and
          o_Output <= "000100110010100000";
        when "101111" => -- nor
          o_Output <= "000101100010100000";
        when "100110" => -- xor
          o_Output <= "010101010010100000";
        when "100101" => -- or
          o_Output <= "000101000010100000";
        when "101010" => -- slt
          o_Output <= "001110000010100000"; -- Verify this output
        when "000000" => -- sll
          o_Output <= "100100100010100000"; 
        when "000010" => -- srl
          o_Output <= "100100010010100000"; 
        when "000011" => -- sra
          o_Output <= "100110010010100000";
        when "000100" => -- sllv
          o_Output <= "000100100010100000"; -- Verify this output
        when "000110" => -- srlv
          o_Output <= "000100010010100000"; -- Verify this output
        when "000111" => -- srav
          o_Output <= "000110010010100000"; -- Verify this output
        when "100010" => -- sub
          o_Output <= "000110000010100000";
        when "100011" => -- subu
          o_Output <= "000010000010100000";
        when "001000" => -- jr
          o_Output <= "000100000000100001";
        when others =>
          o_Output <= (others => '0'); -- Default cases
      end case;
    end if;

  end process;
end architecture;
