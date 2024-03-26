-------------------------------------------------------------------------
--@Author Alek Norris
--@Creation 03/03/24
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
    o_Output        : out std_logic_vector(20 downto 0)
  );
end entity;

architecture sel_when of ControlDecoderLogic is

begin
  op: process (i_instruct31_26, i_instruct5_0) --I Or R Type
  begin

    if i_instruct31_26 = "000000" then
      -- i_instruct31_26 are all zeros, select based on i_instruct5_0
      case i_instruct5_0 is --I and J type
        when "010100" => -- halt bit [18]
          o_Output <= "010000000000000000000";
        when "100000" => -- add
          o_Output <= "000001000000010100000";
        when "100001" => -- addu
          o_Output <= "000000000000010100000";
        when "100100" => -- and
          o_Output <= "000000001100010100000";
        when "100111" => -- nor
          o_Output <= "000000011000010100000";
        when "100110" => -- xor
          o_Output <= "000000010100010100000";
        when "100101" => -- or
          o_Output <= "000000010000010100000";
        when "101010" => -- slt
          o_Output <= "000010100000010100000";
        when "000000" => -- sll
          o_Output <= "001000001000010100000"; 
        when "000010" => -- srl
          o_Output <= "001000000100010100000"; 
        when "000011" => -- sra
          o_Output <= "001000100100010100000";
        when "000100" => -- sllv
          o_Output <= "000000001000010100000";
        when "000110" => -- srlv
          o_Output <= "000000000100010100000";
        when "000111" => -- srav
          o_Output <= "000000100100010100000";
        when "100010" => -- sub
          o_Output <= "000001100000010100000";
        when "100011" => -- subu
          o_Output <= "000000100000010100000";
        when "001000" => -- jr
          o_Output <= "000000000000000100001";
        when others =>
          o_Output <= (others => '0'); -- Default cases
      end case;

    else
      -- i_instruct31_26 are not all zeros, select based on i_instruct31_26 I Type
      case i_instruct31_26 is
      when "010100" => -- halt bit [18]
          o_Output <= "010000000000000000000";
        when "001000" => -- addi
          o_Output <= "000101000000010000100";
        when "001001" => -- addiu
          o_Output <= "000100000000010000100";
        when "001100" => -- andi
          o_Output <= "000100001100010000000";
        when "001111" => -- lui
          o_Output <= "000100011100010000100";
        when "100011" => -- lw
          o_Output <= "000101000011010000100"; 
        when "001110" => -- xori
          o_Output <= "000100010100010000000";
        when "001101" => -- ori
          o_Output <= "000100010000010000000";
        when "001010" => -- slti
          o_Output <= "000110100000010000100";
        when "101011" => -- sw
          o_Output <= "000100000000100000000";
        when "000100" => -- beq
          o_Output <= "100001100000000001000";
        when "000101" => -- bne
          o_Output <= "000001100000000011000";
        when "100000" => -- lb
          o_Output <= "000100000001010000100";
        when "100001" => -- lh
          o_Output <= "000101000010010000000";
        when "100100" => -- lbu
          o_Output <= "000101000001010000000";
        when "100101" => -- lhu
          o_Output <= "000101000010010000100";
        when "000010" => -- jump
          o_Output <= "000101000000000010000";
        when "000011" => -- jal
          o_Output <= "000101000000011110010";
        when others =>
          o_Output <= (others => '0');  --default case
      end case;
    end if;

  end process;
end architecture;
