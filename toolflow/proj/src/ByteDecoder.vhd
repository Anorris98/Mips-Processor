library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ByteDecoder is
    Port ( i_offset : in STD_LOGIC_VECTOR(1 downto 0);
           o_output : out STD_LOGIC_VECTOR(4 downto 0));
end ByteDecoder;

architecture Behavioral of ByteDecoder is
begin
    process(i_offset)
    begin
        case i_offset is
            when "00" =>
                o_output <= "11000";
            when "01" =>
                o_output <= "10000";
            when "10" =>
                o_output <= "01000";
            when "11" =>
                o_output <= "00000";
            when others =>
                o_output <= "XXXXX"; -- Undefined/invalid input handling.
        end case;
    end process;
end Behavioral;
